import '../entities/auth_session.dart';

/// In-memory holder of the signed-in session.
abstract interface class SessionStore {
  AuthSession? get current;

  void save(AuthSession session);

  void clear();
}
