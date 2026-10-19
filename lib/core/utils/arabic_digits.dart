const _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

extension ArabicDigits on String {
  String get toArabicDigits =>
      replaceAllMapped(RegExp('[0-9]'), (m) => _arabicDigits[int.parse(m[0]!)]);
}

extension LatinAmount on num {
  /// Rounded amount with Latin digits and comma separators, e.g. 65,000
  String get toLatinAmount => round().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
}

extension ArabicAmount on num {
  /// Rounded amount with Arabic digits and the Arabic thousands separator,
  /// e.g. 65000 -> ٦٥٬٠٠٠
  String get toArabicAmount => round()
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '٬')
      .toArabicDigits;
}
