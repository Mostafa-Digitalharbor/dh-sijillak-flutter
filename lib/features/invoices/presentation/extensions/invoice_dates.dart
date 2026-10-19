import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/formatting/calendar_days.dart';

/// Locale-aware date formatting for the billing screens.
extension InvoiceDates on BuildContext {
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

  String _monthName(DateTime date) =>
      l10n.monthName(_monthKeys[date.month - 1]);

  /// "17 October" / "October 17".
  String dayMonth(DateTime date) =>
      l10n.dateDayMonth(digits('${date.day}'), _monthName(date));

  /// "15 October 2026" / "October 15, 2026".
  String dayMonthYear(DateTime date) => l10n.dateDayMonthYear(
    digits('${date.day}'),
    _monthName(date),
    digits('${date.year}'),
  );

  /// "Today" when [date] is the current day, otherwise [dayMonthYear].
  String dateOrToday(DateTime date) =>
      date.calendarDaysUntil(DateTime.now()) == 0
      ? l10n.today
      : dayMonthYear(date);
}
