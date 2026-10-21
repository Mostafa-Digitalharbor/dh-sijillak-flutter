import 'package:equatable/equatable.dart';

import 'app_notification.dart';
import 'notification_day_bucket.dart';

/// Notifications of one [NotificationDayBucket], newest first.
class NotificationGroup extends Equatable {
  const NotificationGroup({required this.bucket, required this.items});

  final NotificationDayBucket bucket;
  final List<AppNotification> items;

  /// Splits [notifications] into today / yesterday / earlier groups (empty
  /// groups left out, newest notification first inside each).
  static List<NotificationGroup> byDay(
    List<AppNotification> notifications, {
    required DateTime now,
  }) {
    final sorted = [...notifications]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final groups = <NotificationGroup>[];
    for (final bucket in NotificationDayBucket.values) {
      final items = [
        for (final n in sorted)
          if (NotificationDayBucket.of(n.createdAt, now: now) == bucket) n,
      ];
      if (items.isNotEmpty) {
        groups.add(NotificationGroup(bucket: bucket, items: items));
      }
    }
    return groups;
  }

  @override
  List<Object?> get props => [bucket, items];
}
