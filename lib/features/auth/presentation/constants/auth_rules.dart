/// Validation rules and limits of the registration flow.
abstract final class AuthRules {
  // Password strength
  static const int passwordMinLength = 8;
  static const int passwordStrongLength = 12;
  static const int strengthBars = 3;
  static final digitPattern = RegExp('[0-9]');
  static final letterPattern = RegExp('[a-zA-Z]');
  static final symbolPattern = RegExp('[^a-zA-Z0-9]');

  /// Quiet time after typing before the handle availability is checked.
  static const Duration handleDebounce = Duration(milliseconds: 400);

  // One-time code
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;

  /// Empty slot and delete key of the numeric keypad.
  static const String keypadBlank = '';
  static const String keypadDelete = 'del';

  /// Glyph drawn on the delete key.
  static const String backspaceGlyph = '⌫';

  static const List<List<String>> keypadRows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [keypadBlank, '0', keypadDelete],
  ];
}
