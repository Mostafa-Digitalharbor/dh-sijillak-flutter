/// Paths of the notifications API.
abstract final class NotificationsEndpoints {
  static const notifications = '/notifications';
  static const unreadCount = '/notifications/unread-count';
  static const readAll = '/notifications/read-all';
  static const idParam = 'id';
  static const readPattern = '/notifications/:$idParam/read';

  /// Path that marks the notification [id] as read.
  static String read(String id) =>
      '$notifications/${Uri.encodeComponent(id)}/read';
}
