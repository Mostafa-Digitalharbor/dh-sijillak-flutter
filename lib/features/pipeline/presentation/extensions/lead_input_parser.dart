/// Reads the free-text number and date fields of the new-deal form.
abstract final class LeadInputParser {
  static const _arabicIndicZero = 0x0660;
  static const _easternArabicIndicZero = 0x06F0;
  static const _digitCount = 10;
  static final _separators = RegExp(r'[\s,.٬٫]');
  static final _numericDate = RegExp(
    r'^(\d{1,4})[/\-.](\d{1,2})(?:[/\-.](\d{1,4}))?$',
  );
  static final _dayAndMonthName = RegExp(r'^(\d{1,2})\s+(\S+)$');
  static const _yearDigits = 4;

  /// [text] with Arabic-Indic and Persian digits turned into ASCII digits.
  static String latinDigits(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final arabic = rune - _arabicIndicZero;
      final persian = rune - _easternArabicIndicZero;
      if (arabic >= 0 && arabic < _digitCount) {
        buffer.write(arabic);
      } else if (persian >= 0 && persian < _digitCount) {
        buffer.write(persian);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// A whole amount such as 65,000 (in any digit script), or null when
  /// [text] is not one.
  static int? amount(String text) =>
      int.tryParse(latinDigits(text).replaceAll(_separators, ''));

  /// A date typed as day/month, day/month/year, year-month-day or as a day
  /// followed by a month name. Without a year, the next occurrence of that
  /// day on or after [now] is used. [monthNames] maps a lower-case month name
  /// to its number (1 to 12).
  static DateTime? date(
    String text, {
    required DateTime now,
    required Map<String, int> monthNames,
  }) {
    final input = latinDigits(text.trim());
    if (input.isEmpty) return null;
    final numeric = _numericDate.firstMatch(input);
    if (numeric != null) {
      final first = int.parse(numeric.group(1)!);
      final second = int.parse(numeric.group(2)!);
      final third = numeric.group(3);
      if (third == null) return _next(first, second, now);
      return numeric.group(1)!.length == _yearDigits
          ? _valid(first, second, int.parse(third))
          : _valid(int.parse(third), second, first);
    }
    final named = _dayAndMonthName.firstMatch(input);
    if (named == null) return null;
    final month = monthNames[named.group(2)!.toLowerCase()];
    return month == null ? null : _next(int.parse(named.group(1)!), month, now);
  }

  static DateTime? _next(int day, int month, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final thisYear = _valid(today.year, month, day);
    if (thisYear == null || thisYear.isBefore(today)) {
      return _valid(today.year + 1, month, day);
    }
    return thisYear;
  }

  static DateTime? _valid(int year, int month, int day) {
    final date = DateTime(year, month, day);
    final real = date.year == year && date.month == month && date.day == day;
    return real ? date : null;
  }
}
