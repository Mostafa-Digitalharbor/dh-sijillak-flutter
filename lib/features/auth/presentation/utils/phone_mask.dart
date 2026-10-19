/// Constants of the masked phone shown on the OTP step.
abstract final class PhoneMaskRules {
  static const String bullet = '•';
  static const String separator = ' ';

  /// National prefix shown before the subscriber number.
  static const String nationalPrefix = '0';

  /// Digits kept visible at the start and at the end.
  static const int visibleHead = 3;
  static const int visibleTail = 2;

  /// Bullets of the first group after the visible head.
  static const int firstBulletGroup = 3;

  static final _arabicIndic = RegExp('[٠-٩]');
  static final _nonDigit = RegExp('[^0-9]');
}

/// Hides the middle of [phone], e.g. `500000045` -> `050 ••• ••45`.
///
/// Arabic-Indic digits are accepted; the result has Latin digits so the
/// caller can localise them. A number too short to hide anything is returned
/// as its digits only.
String maskPhone(String phone) {
  final latin = phone.replaceAllMapped(
    PhoneMaskRules._arabicIndic,
    (m) => (m[0]!.codeUnitAt(0) - '٠'.codeUnitAt(0)).toString(),
  );
  var digits = latin.replaceAll(PhoneMaskRules._nonDigit, '');
  if (digits.isEmpty) return '';
  if (!digits.startsWith(PhoneMaskRules.nationalPrefix)) {
    digits = '${PhoneMaskRules.nationalPrefix}$digits';
  }
  const head = PhoneMaskRules.visibleHead;
  const tail = PhoneMaskRules.visibleTail;
  final hidden = digits.length - head - tail;
  if (hidden <= 0) return digits;
  const bullet = PhoneMaskRules.bullet;
  final first = hidden < PhoneMaskRules.firstBulletGroup
      ? hidden
      : PhoneMaskRules.firstBulletGroup;
  return [
    digits.substring(0, head),
    bullet * first,
    '${bullet * (hidden - first)}${digits.substring(digits.length - tail)}',
  ].join(PhoneMaskRules.separator);
}
