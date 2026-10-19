/// Parses an amount typed in the payment sheet, which may use Arabic-Indic
/// digits and the Arabic thousands / decimal separators.
abstract final class AmountInput {
  static const String _arabicIndicZero = '٠';
  static const String _easternIndicZero = '۰';
  static const int _digitCount = 10;
  static const String _arabicDecimal = '٫';
  static final RegExp _notNumeric = RegExp(r'[^0-9.]');

  /// The whole amount in [text], or 0 when it holds no number.
  static int parse(String text) {
    final latin = StringBuffer();
    for (final unit in text.runes) {
      latin.write(_latinDigit(unit) ?? String.fromCharCode(unit));
    }
    final cleaned = latin
        .toString()
        .replaceAll(_arabicDecimal, '.')
        .replaceAll(_notNumeric, '');
    return (double.tryParse(cleaned) ?? 0).round();
  }

  static String? _latinDigit(int rune) {
    for (final zero in [_arabicIndicZero, _easternIndicZero]) {
      final offset = rune - zero.codeUnitAt(0);
      if (offset >= 0 && offset < _digitCount) return '$offset';
    }
    return null;
  }
}
