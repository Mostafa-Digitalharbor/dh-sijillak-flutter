import '../../../../shared/formatting/calendar_days.dart';

/// How long ago, in calendar days, a group of notifications happened.
enum NotificationDayBucket {
  today,
  yesterday,
  earlier;

  /// The bucket of a moment [at] seen from [now].
  static NotificationDayBucket of(DateTime at, {required DateTime now}) =>
      switch (at.calendarDaysUntil(now)) {
        <= 0 => today,
        1 => yesterday,
        _ => earlier,
      };
}
