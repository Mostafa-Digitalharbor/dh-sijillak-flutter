import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/features/notifications/domain/entities/app_notification.dart';
import 'package:sijilak/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:sijilak/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:sijilak/features/notifications/presentation/cubit/notifications_cubit.dart';

import '../helpers/pump_route.dart';
import '../helpers/test_dependencies.dart';

/// A repository with no notifications at all.
class _EmptyRepository implements NotificationsRepository {
  @override
  Future<Result<List<AppNotification>>> getNotifications() async =>
      const Success([]);

  @override
  Future<Result<int>> getUnreadCount() async => const Success(0);

  @override
  Future<Result<AppNotification>> markRead(String id) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> markAllRead() async => const Success(null);
}

/// The notifications screen in English with a list, and in both languages
/// with the empty state, on every spec.
void main() {
  for (final device in DeviceSpec.all) {
    testWidgets('notifications (en) fits ${device.name}', (tester) async {
      await pumpRoute(
        tester,
        AppRoutes.notifications,
        device,
        locale: const Locale('en'),
      );
      expect(tester.takeException(), isNull);
    });

    for (final locale in const [Locale('ar'), Locale('en')]) {
      testWidgets(
        'empty notifications (${locale.languageCode}) fit ${device.name}',
        (tester) async {
          applyDevice(tester, device);
          await loadAppFonts();
          SharedPreferences.setMockInitialValues({});
          await configureTestDependencies();
          final repository = _EmptyRepository();
          getIt
            ..unregister<NotificationsCubit>()
            ..registerFactory(
              () => NotificationsCubit(
                GetNotificationsUseCase(repository),
                MarkNotificationReadUseCase(repository),
                MarkAllNotificationsReadUseCase(repository),
              ),
            );
          try {
            appRouter.go(AppRoutes.notifications);
            await tester.pumpWidget(SijilakApp(locale: locale));
            await settle(tester);
          } finally {
            resetPlatform();
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
