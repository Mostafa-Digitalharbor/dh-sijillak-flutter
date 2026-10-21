import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/notifications/data/datasources/notifications_mock_api.dart';
import 'package:sijilak/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:sijilak/features/notifications/data/models/notification_model.dart';
import 'package:sijilak/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:sijilak/features/notifications/domain/entities/app_notification.dart';
import 'package:sijilak/features/notifications/domain/entities/notification_day_bucket.dart';
import 'package:sijilak/features/notifications/domain/entities/notification_group.dart';
import 'package:sijilak/features/notifications/domain/entities/notification_kind.dart';
import 'package:sijilak/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:sijilak/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/get_unread_count_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:sijilak/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:sijilak/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:sijilak/features/notifications/presentation/cubit/unread_count_cubit.dart';

class _FailingRemote implements NotificationsRemoteDataSource {
  @override
  Future<List<AppNotification>> fetchNotifications() async =>
      throw const NetworkException();

  @override
  Future<int> fetchUnreadCount() async => throw const NetworkException();

  @override
  Future<AppNotification> markRead(String id) async =>
      throw const NetworkException();

  @override
  Future<void> markAllRead() async => throw const NetworkException();
}

/// Delegates to [_inner] until [failing] is switched on.
class _SwitchRemote implements NotificationsRemoteDataSource {
  _SwitchRemote(this._inner);

  final NotificationsRemoteDataSource _inner;
  bool failing = false;

  T _guard<T>(T Function() call) =>
      failing ? throw const NetworkException() : call();

  @override
  Future<List<AppNotification>> fetchNotifications() async =>
      _guard(_inner.fetchNotifications);

  @override
  Future<int> fetchUnreadCount() async => _guard(_inner.fetchUnreadCount);

  @override
  Future<AppNotification> markRead(String id) async =>
      _guard(() => _inner.markRead(id));

  @override
  Future<void> markAllRead() async => _guard(_inner.markAllRead);
}

AppNotification _at(String id, DateTime at, {bool read = false}) =>
    AppNotification(
      id: id,
      kind: NotificationKind.quoteViewed,
      createdAt: at,
      isRead: read,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 20, 15);
  late NotificationsRepository repository;
  late GetNotificationsUseCase getNotifications;
  late GetUnreadCountUseCase getUnreadCount;
  late MarkNotificationReadUseCase markRead;
  late MarkAllNotificationsReadUseCase markAllRead;

  setUp(() {
    final client = MockApiClient(
      modules: [NotificationsMockApi(MockAssets(), clock: () => now)],
    );
    repository = NotificationsRepositoryImpl(
      NotificationsRemoteDataSourceImpl(client),
    );
    getNotifications = GetNotificationsUseCase(repository);
    getUnreadCount = GetUnreadCountUseCase(repository);
    markRead = MarkNotificationReadUseCase(repository);
    markAllRead = MarkAllNotificationsReadUseCase(repository);
  });

  group('use cases on the mock backend', () {
    test(
      'serve every kind, newest first, with times relative to now',
      () async {
        final items = (await getNotifications(const NoParams())).dataOrNull!;

        expect(items, hasLength(8));
        expect(
          items.map((n) => n.kind).toSet(),
          NotificationKind.values.toSet(),
        );
        final times = items.map((n) => n.createdAt).toList();
        expect([...times]..sort((a, b) => b.compareTo(a)), times);
        expect(
          items.first.createdAt,
          now.subtract(const Duration(minutes: 25)),
        );
        expect(items.first.quoteNumber, 142);
        expect(items.where((n) => !n.isRead), hasLength(4));
      },
    );

    test('count the unread ones', () async {
      expect((await getUnreadCount(const NoParams())).dataOrNull, 4);
    });

    test('marking one read lowers the unread count', () async {
      final read = (await markRead('n-1')).dataOrNull!;

      expect(read.id, 'n-1');
      expect(read.isRead, isTrue);
      expect((await getUnreadCount(const NoParams())).dataOrNull, 3);
      final items = (await getNotifications(const NoParams())).dataOrNull!;
      expect(items.firstWhere((n) => n.id == 'n-1').isRead, isTrue);
    });

    test('marking the same notification twice changes nothing more', () async {
      await markRead('n-1');
      await markRead('n-1');

      expect((await getUnreadCount(const NoParams())).dataOrNull, 3);
    });

    test('marking an unknown id is a not-found failure', () async {
      final result = await markRead('nope');

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });

    test('marking all read empties the unread count', () async {
      expect((await markAllRead(const NoParams())).isSuccess, isTrue);

      expect((await getUnreadCount(const NoParams())).dataOrNull, 0);
      final items = (await getNotifications(const NoParams())).dataOrNull!;
      expect(items.every((n) => n.isRead), isTrue);
    });

    test('turn a data source error into a failure', () async {
      final failing = NotificationsRepositoryImpl(_FailingRemote());

      expect(
        (await GetNotificationsUseCase(failing)(const NoParams()))
            .failureOrNull,
        isA<NetworkFailure>(),
      );
      expect(
        (await GetUnreadCountUseCase(failing)(const NoParams())).failureOrNull,
        isA<NetworkFailure>(),
      );
      expect(
        (await MarkNotificationReadUseCase(failing)('n-1')).failureOrNull,
        isA<NetworkFailure>(),
      );
      expect(
        (await MarkAllNotificationsReadUseCase(failing)(const NoParams()))
            .failureOrNull,
        isA<NetworkFailure>(),
      );
    });
  });

  group('NotificationModel', () {
    test('survives a toJson/fromJson round trip', () async {
      final items = (await getNotifications(const NoParams())).dataOrNull!;

      for (final item in items) {
        expect(
          NotificationModel.fromJson(NotificationModel.toJson(item)),
          item,
        );
      }
    });
  });

  group('grouping by day', () {
    test('splits into today, yesterday and earlier, newest first', () {
      final groups = NotificationGroup.byDay([
        _at('old', DateTime(2026, 10, 15, 9)),
        _at('y', DateTime(2026, 10, 19, 23, 59)),
        _at('t1', DateTime(2026, 10, 20, 1)),
        _at('t2', DateTime(2026, 10, 20, 14)),
      ], now: now);

      expect(groups.map((g) => g.bucket), NotificationDayBucket.values);
      expect(groups[0].items.map((n) => n.id), ['t2', 't1']);
      expect(groups[1].items.map((n) => n.id), ['y']);
      expect(groups[2].items.map((n) => n.id), ['old']);
    });

    test('uses calendar days, not 24-hour spans', () {
      final nearMidnight = DateTime(2026, 10, 20, 0, 5);

      expect(
        NotificationDayBucket.of(
          DateTime(2026, 10, 19, 23, 50),
          now: nearMidnight,
        ),
        NotificationDayBucket.yesterday,
      );
      expect(
        NotificationDayBucket.of(
          DateTime(2026, 10, 18, 23, 59),
          now: nearMidnight,
        ),
        NotificationDayBucket.earlier,
      );
    });

    test('leaves out empty groups and handles an empty list', () {
      expect(NotificationGroup.byDay(const [], now: now), isEmpty);
      final groups = NotificationGroup.byDay([
        _at('y', DateTime(2026, 10, 19, 10)),
      ], now: now);
      expect(groups.map((g) => g.bucket), [NotificationDayBucket.yesterday]);
    });

    test('groups the fixture: 3 today, 2 yesterday, 3 earlier', () async {
      final items = (await getNotifications(const NoParams())).dataOrNull!;

      final groups = NotificationGroup.byDay(items, now: now);

      expect(groups.map((g) => g.items.length), [3, 2, 3]);
    });
  });

  group('NotificationsCubit', () {
    NotificationsCubit cubit0() =>
        NotificationsCubit(getNotifications, markRead, markAllRead);

    test('loads the notifications', () async {
      final cubit = cubit0();
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.notifications, hasLength(8));
      expect(cubit.state.unreadCount, 4);
    });

    test('reports a load failure', () async {
      final failing = NotificationsRepositoryImpl(_FailingRemote());
      final cubit = NotificationsCubit(
        GetNotificationsUseCase(failing),
        MarkNotificationReadUseCase(failing),
        MarkAllNotificationsReadUseCase(failing),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, isA<NetworkFailure>());
    });

    test('markRead updates the list and the server', () async {
      final cubit = cubit0();
      addTearDown(cubit.close);
      await cubit.load();

      await cubit.markRead('n-1');

      expect(cubit.state.unreadCount, 3);
      expect((await getUnreadCount(const NoParams())).dataOrNull, 3);
    });

    test('markAllRead updates the list and the server', () async {
      final cubit = cubit0();
      addTearDown(cubit.close);
      await cubit.load();

      await cubit.markAllRead();

      expect(cubit.state.unreadCount, 0);
      expect((await getUnreadCount(const NoParams())).dataOrNull, 0);
    });

    test('rolls back and reports when saving fails', () async {
      final failing = NotificationsRepositoryImpl(_FailingRemote());
      final cubit = NotificationsCubit(
        getNotifications,
        MarkNotificationReadUseCase(failing),
        MarkAllNotificationsReadUseCase(failing),
      );
      addTearDown(cubit.close);
      await cubit.load();

      await cubit.markRead('n-1');
      expect(cubit.state.unreadCount, 4);
      expect(cubit.state.actionFailure, isA<NetworkFailure>());

      await cubit.markAllRead();
      expect(cubit.state.unreadCount, 4);
      expect(cubit.state.actionFailure, isA<NetworkFailure>());
    });
  });

  group('UnreadCountCubit', () {
    test('loads the count and follows later changes', () async {
      final cubit = UnreadCountCubit(getUnreadCount);
      addTearDown(cubit.close);
      expect(cubit.state, 0);

      await cubit.load();
      expect(cubit.state, 4);

      await markAllRead(const NoParams());
      await cubit.load();
      expect(cubit.state, 0);
    });

    test('keeps the last count when refreshing fails', () async {
      final remote = _SwitchRemote(
        NotificationsRemoteDataSourceImpl(
          MockApiClient(
            modules: [NotificationsMockApi(MockAssets(), clock: () => now)],
          ),
        ),
      );
      final cubit = UnreadCountCubit(
        GetUnreadCountUseCase(NotificationsRepositoryImpl(remote)),
      );
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state, 4);

      remote.failing = true;
      await cubit.load();

      expect(cubit.state, 4);
    });
  });
}
