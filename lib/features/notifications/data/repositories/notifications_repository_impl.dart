import '../../../../core/utils/result.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._dataSource);

  final NotificationsRemoteDataSource _dataSource;

  @override
  Future<Result<List<AppNotification>>> getNotifications() =>
      Result.guard(_dataSource.fetchNotifications);

  @override
  Future<Result<int>> getUnreadCount() =>
      Result.guard(_dataSource.fetchUnreadCount);

  @override
  Future<Result<AppNotification>> markRead(String id) =>
      Result.guard(() => _dataSource.markRead(id));

  @override
  Future<Result<void>> markAllRead() => Result.guard(_dataSource.markAllRead);
}
