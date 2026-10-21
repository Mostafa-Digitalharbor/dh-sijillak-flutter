import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/session_store.dart';

/// Keeps the session in memory for the life of the app.
class InMemorySessionStore implements SessionStore {
  AuthSession? _current;
  AuthSession? _remembered;

  @override
  AuthSession? get current => _current;

  @override
  AuthSession? get remembered => _remembered;

  @override
  void save(AuthSession session) {
    _current = session;
    _remembered = session;
  }

  @override
  void clear() => _current = null;

  @override
  void forgetRemembered() => _remembered = null;
}
