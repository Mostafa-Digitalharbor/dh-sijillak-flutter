/// JSON keys, error codes and fixture paths shared by the auth API client and
/// its mock backend.
abstract final class AuthApiFields {
  static const handle = 'handle';
  static const available = 'available';
  static const phone = 'phone';
  static const code = 'code';
  static const email = 'email';
  static const password = 'password';

  /// Error codes reported per field by validation errors.
  static const requiredCode = 'required';
  static const invalidCode = 'invalid';
  static const takenCode = 'taken';

  /// Field and code of the error raised when no earlier sign-in exists.
  static const biometric = 'biometric';
  static const noCredentialCode = 'no_credential';

  /// Fixture holding the demo user and workspace.
  static const sessionFixture = 'assets/mock/auth/session.json';
}
