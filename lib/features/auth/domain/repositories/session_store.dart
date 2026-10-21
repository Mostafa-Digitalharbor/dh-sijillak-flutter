import '../entities/auth_session.dart';

/// Holder of the signed-in session. Reads are synchronous (served from
/// memory); implementations persist writes in the background.
abstract interface class SessionStore {
  /// The signed-in session, or null.
  AuthSession? get current;

  /// The most recent session that was saved, kept after [clear] so biometric
  /// sign-in can resume it with its refresh token. Null until the first
  /// sign-in or after [forgetRemembered].
  AuthSession? get remembered;

  /// Makes [session] current and remembers it.
  void save(AuthSession session);

  /// Signs out: forgets [current] but keeps [remembered].
  void clear();

  /// Forgets the remembered session too (its refresh token was rejected).
  void forgetRemembered();
}
