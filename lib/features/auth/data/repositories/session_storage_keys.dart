/// Keys under which the session is persisted on the device.
abstract final class SessionStorageKeys {
  /// Secure storage: JSON of the signed-in session (user, workspace, tokens).
  static const session = 'auth.session.secure';

  /// Secure storage: JSON of the remembered session used for biometric
  /// sign-in.
  static const remembered = 'auth.session.remembered';

  /// Shared preferences: where earlier versions kept the session in clear
  /// text. Read once to migrate, then deleted.
  static const legacyPreferencesSession = 'auth.session';
}
