import '../../../../core/utils/result.dart';
import '../entities/app_notification.dart';

/// Source of the user's notifications.
abstract interface class NotificationsRepository {
  Future<Result<List<AppNotification>>> getNotifications();

  Future<Result<int>> getUnreadCount();

  Future<Result<AppNotification>> markRead(String id);

  Future<Result<void>> markAllRead();
}
