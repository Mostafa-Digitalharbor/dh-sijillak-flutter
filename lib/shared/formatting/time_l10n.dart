import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/l10n/l10n.dart';
import 'calendar_days.dart';

/// Locale-aware rendering of the DateTimes that entities carry: clock times,
/// short dates, weekdays and "how long ago" phrases.
extension TimeL10n on BuildContext {
  static const _monthKeys = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec',
  ];

  static const _weekdayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  static const _hoursOnClockFace = 12;
  static const _minutesPerHour = 60;
  static const _daysPerWeek = 7;

  /// "10:30 AM" / "١٠:٣٠ ص" (12-hour clock).
  String clockTime(DateTime time) {
    final hour = time.hour % _hoursOnClockFace;
    final period = time.hour < _hoursOnClockFace
        ? l10n.timePeriodAm
        : l10n.timePeriodPm;
    return l10n.clockTime(
      digits('${hour == 0 ? _hoursOnClockFace : hour}'),
      digits(time.minute.toString().padLeft(2, '0')),
      period,
    );
  }

  /// "17 October" / "October 17".
  String shortDate(DateTime date) => l10n.dateDayMonth(
    digits('${date.day}'),
    l10n.monthName(_monthKeys[date.month - 1]),
  );

  /// "Sunday" / "الأحد".
  String weekdayOf(DateTime date) =>
      l10n.weekdayName(_weekdayKeys[date.weekday - DateTime.monday]);

  /// Past moment relative to [now]: minutes or hours when it was today,
  /// otherwise "yesterday" / "N days ago" and a plain date after a week.
  String relativePast(DateTime at, {required DateTime now}) {
    final days = at.calendarDaysUntil(now);
    if (days <= 0) {
      final minutes = now.difference(at).inMinutes;
      if (minutes < 1) return l10n.relativeJustNow;
      if (minutes < _minutesPerHour) {
        return l10n.relativeMinutesAgo(minutes, digits('$minutes'));
      }
      final hours = minutes ~/ _minutesPerHour;
      return l10n.relativeHoursAgo(hours, digits('$hours'));
    }
    if (days >= _daysPerWeek) return shortDate(at);
    return l10n.relativeDaysAgo(days, digits('$days'));
  }

  /// "Overdue by 5 days" for an invoice that fell due at [dueAt].
  String overdueSince(DateTime dueAt, {required DateTime now}) {
    final days = math.max(0, dueAt.calendarDaysUntil(now));
    return l10n.overdueSinceDays(days, digits('$days'));
  }
}
