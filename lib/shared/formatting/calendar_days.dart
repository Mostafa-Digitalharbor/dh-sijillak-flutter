/// Calendar-day arithmetic that ignores the time of day.
extension CalendarDays on DateTime {
  /// Whole calendar days from this date to [other] (positive when [other] is
  /// later), regardless of the hours and minutes of either.
  int calendarDaysUntil(DateTime other) => DateTime.utc(
    other.year,
    other.month,
    other.day,
  ).difference(DateTime.utc(year, month, day)).inDays;
}
