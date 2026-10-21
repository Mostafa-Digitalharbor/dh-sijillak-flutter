import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/features/home/presentation/widgets/notification_bell.dart';
import 'package:sijilak/features/notifications/domain/entities/app_notification.dart';
import 'package:sijilak/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:sijilak/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:sijilak/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:sijilak/features/notifications/presentation/widgets/notifications_list.dart';
import 'package:sijilak/l10n/gen/app_localizations_ar.dart';
import 'package:sijilak/l10n/gen/app_localizations_en.dart';

import '../../helpers/pump_route.dart';
import '../../helpers/test_dependencies.dart';

const _device = DeviceSpec('phone', Size(390, 844));

/// A repository that serves a fixed result, for the empty and error states.
class _FixedRepository implements NotificationsRepository {
  const _FixedRepository(this.result);

  final Result<List<AppNotification>> result;

  @override
  Future<Result<List<AppNotification>>> getNotifications() async => result;

  @override
  Future<Result<int>> getUnreadCount() async => const Success(0);

  @override
  Future<Result<AppNotification>> markRead(String id) async =>
      const Failed(UnknownFailure());

  @override
  Future<Result<void>> markAllRead() async => const Success(null);
}

/// Boots the real app on [route] with the mock backend. [repository] swaps
/// the notifications repository the screen uses.
Future<void> _boot(
  WidgetTester tester,
  String route, {
  Locale locale = const Locale('ar'),
  NotificationsRepository? repository,
  DeviceSpec device = _device,
}) async {
  applyDevice(tester, device);
  await loadAppFonts();
  SharedPreferences.setMockInitialValues({});
  await configureTestDependencies();
  if (repository != null) {
    getIt
      ..unregister<NotificationsCubit>()
      ..registerFactory(
        () => NotificationsCubit(
          GetNotificationsUseCase(repository),
          MarkNotificationReadUseCase(repository),
          MarkAllNotificationsReadUseCase(repository),
        ),
      );
  }
  try {
    appRouter.go(route);
    await tester.pumpWidget(SijilakApp(locale: locale));
    await settle(tester);
  } finally {
    resetPlatform();
  }
}

/// The top-most location, including screens pushed over the current page.
String get _path =>
    appRouter.routerDelegate.currentConfiguration.matches.last.matchedLocation;

NotificationsCubit _cubit(WidgetTester tester) =>
    tester.element(find.byType(NotificationsList)).read<NotificationsCubit>();

Future<void> _tapRow(WidgetTester tester, Finder row) async {
  await tester.scrollUntilVisible(
    row,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.tap(row);
  await settle(tester);
}

void main() {
  final ar = AppLocalizationsAr();
  final en = AppLocalizationsEn();

  testWidgets('lists the notifications grouped by day (ar)', (tester) async {
    await _boot(tester, AppRoutes.notifications);

    expect(find.text(ar.notifications), findsOneWidget);
    expect(find.text(ar.notifMarkAllRead), findsOneWidget);
    expect(find.text(ar.today), findsOneWidget);
    expect(find.text(ar.notifGroupYesterday), findsWidgets);
    expect(
      find.text(ar.notifQuoteViewedTitle('مصنع الأغذية الحديثة')),
      findsOneWidget,
    );
    expect(
      find.text(ar.notifQuoteBody('١٤٢', ar.amountSar('٦٥٬٠٠٠'))),
      findsOneWidget,
    );
    expect(find.text(ar.relativeMinutesAgo(25, '٢٥')), findsOneWidget);
    expect(_cubit(tester).state.unreadCount, 4);
  });

  testWidgets('composes the wording from the locale (en)', (tester) async {
    await _boot(tester, AppRoutes.notifications, locale: const Locale('en'));

    expect(find.text(en.notifMarkAllRead), findsOneWidget);
    expect(find.text(en.today), findsOneWidget);
    expect(
      find.text(en.notifQuoteViewedTitle('مصنع الأغذية الحديثة')),
      findsOneWidget,
    );
    expect(
      find.text(en.notifQuoteBody('142', en.amountSar('65,000'))),
      findsOneWidget,
    );
    expect(find.text(en.relativeMinutesAgo(25, '25')), findsOneWidget);
  });

  group('tapping a notification', () {
    final targets = {
      'a viewed quote opens the quote': (
        ar.notifQuoteViewedTitle('مصنع الأغذية الحديثة'),
        AppRoutes.quote,
      ),
      'an overdue invoice opens the invoice': (
        ar.notifInvoiceOverdueTitle('٣٨٨'),
        AppRoutes.invoice,
      ),
      'a won deal opens the pipeline': (
        ar.notifDealWonTitle('مصنع الأغذية الحديثة'),
        AppRoutes.pipeline,
      ),
    };
    for (final entry in targets.entries) {
      testWidgets(entry.key, (tester) async {
        await _boot(tester, AppRoutes.notifications);

        await _tapRow(tester, find.text(entry.value.$1));

        expect(_path, entry.value.$2);
      });
    }

    testWidgets('a task reminder opens its customer', (tester) async {
      await _boot(tester, AppRoutes.notifications);

      await _tapRow(tester, find.text(ar.notifTaskReminderTitle).last);

      expect(_path, AppRoutes.customer);
    });

    testWidgets('marks it read, also once back on the list', (tester) async {
      await _boot(tester, AppRoutes.notifications);
      final cubit = _cubit(tester);
      expect(cubit.state.unreadCount, 4);

      await _tapRow(
        tester,
        find.text(ar.notifQuoteViewedTitle('مصنع الأغذية الحديثة')),
      );
      appRouter.pop();
      await settle(tester);

      expect(_path, AppRoutes.notifications);
      expect(cubit.state.unreadCount, 3);
      expect(cubit.state.notifications.first.isRead, isTrue);
    });
  });

  testWidgets('"mark all as read" clears every unread notification', (
    tester,
  ) async {
    await _boot(tester, AppRoutes.notifications);
    final cubit = _cubit(tester);
    expect(cubit.state.unreadCount, 4);

    await tester.tap(find.text(ar.notifMarkAllRead));
    await settle(tester);

    expect(cubit.state.unreadCount, 0);
    expect(cubit.state.notifications.every((n) => n.isRead), isTrue);
  });

  testWidgets('shows the empty state without notifications', (tester) async {
    await _boot(
      tester,
      AppRoutes.notifications,
      repository: const _FixedRepository(Success([])),
    );

    expect(find.text(ar.notifEmptyTitle), findsOneWidget);
    expect(find.text(ar.notifEmptyHint), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the error with a retry that reloads', (tester) async {
    await _boot(
      tester,
      AppRoutes.notifications,
      repository: const _FixedRepository(Failed(NetworkFailure())),
    );
    expect(find.text(ar.retry), findsOneWidget);

    await tester.tap(find.text(ar.retry));
    await settle(tester);

    expect(find.text(ar.retry), findsOneWidget);
    expect(find.text(ar.notifEmptyTitle), findsNothing);
  });

  group('home bell', () {
    final dot = find.descendant(
      of: find.byType(NotificationBell),
      matching: find.byType(Positioned),
    );

    testWidgets('shows the dot while unread, hides it after reading all', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _boot(tester, AppRoutes.home);
      expect(dot, findsOneWidget);
      expect(find.bySemanticsLabel(ar.notifBellUnread('٤', 4)), findsOneWidget);

      await tester.tap(find.byType(NotificationBell));
      await settle(tester);
      expect(_path, AppRoutes.notifications);
      await tester.tap(find.text(ar.notifMarkAllRead));
      await settle(tester);
      appRouter.pop();
      await settle(tester);

      expect(_path, AppRoutes.home);
      expect(dot, findsNothing);
      expect(find.bySemanticsLabel(ar.notifications), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('keeps the dot when nothing was read', (tester) async {
      await _boot(tester, AppRoutes.home);

      await tester.tap(find.byType(NotificationBell));
      await settle(tester);
      appRouter.pop();
      await settle(tester);

      expect(_path, AppRoutes.home);
      expect(dot, findsOneWidget);
    });
  });
}
