/// JSON keys, error codes and fixture paths shared by the auth API client and
/// its mock backend.
abstract final class AuthApiFields {
  static const handle = 'handle';
  static const available = 'available';
  static const phone = 'phone';
  static const code = 'code';
  static const email = 'email';
  static const password = 'password';
  static const refreshToken = 'refreshToken';

  /// Error codes reported per field by validation errors.
  static const requiredCode = 'required';
  static const invalidCode = 'invalid';
  static const takenCode = 'taken';

  /// Fixture holding the demo user and workspace.
  static const sessionFixture = 'assets/mock/auth/session.json';
}
