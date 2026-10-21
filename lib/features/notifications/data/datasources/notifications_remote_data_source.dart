import '../../../../core/network/api_client.dart';
import '../../domain/entities/app_notification.dart';
import '../models/notification_model.dart';
import 'notifications_endpoints.dart';

/// Talks to the notifications API.
abstract interface class NotificationsRemoteDataSource {
  Future<List<AppNotification>> fetchNotifications();

  Future<int> fetchUnreadCount();

  Future<AppNotification> markRead(String id);

  Future<void> markAllRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this._client);

  static const _countField = 'count';

  final ApiClient _client;

  @override
  Future<List<AppNotification>> fetchNotifications() async =>
      NotificationModel.listFromJson(
        await _client.get(NotificationsEndpoints.notifications),
      );

  @override
  Future<int> fetchUnreadCount() async {
    final payload = await _client.get(NotificationsEndpoints.unreadCount);
    return (payload.asJson[_countField]! as num).toInt();
  }

  @override
  Future<AppNotification> markRead(String id) async =>
      NotificationModel.fromJson(
        (await _client.post(NotificationsEndpoints.read(id))).asJson,
      );

  @override
  Future<void> markAllRead() async {
    await _client.post(NotificationsEndpoints.readAll);
  }
}
