/// Text normalisation shared by the search matching: case-insensitive, and
/// Arabic-Indic digits equal Latin ones.
abstract final class SearchText {
  static const _arabicIndicZero = 0x0660;
  static const _extendedArabicIndicZero = 0x06F0;
  static const _digitCount = 10;
  static const _latinZero = 0x30;

  /// [text] trimmed, lower-cased, with every digit written as 0-9.
  static String normalize(String text) {
    final buffer = StringBuffer();
    for (final unit in text.trim().toLowerCase().runes) {
      buffer.writeCharCode(_latinDigit(unit));
    }
    return buffer.toString();
  }

  /// Whether any of [fields] contains the already normalised [query].
  static bool matchesAny(String query, Iterable<Object?> fields) =>
      fields.any((field) => normalize('$field').contains(query));

  static int _latinDigit(int unit) {
    for (final zero in const [_arabicIndicZero, _extendedArabicIndicZero]) {
      if (unit >= zero && unit < zero + _digitCount) {
        return _latinZero + unit - zero;
      }
    }
    return unit;
  }
}
