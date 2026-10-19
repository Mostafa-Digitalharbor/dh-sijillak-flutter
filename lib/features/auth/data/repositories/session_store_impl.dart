import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/session_store.dart';

/// Keeps the session in memory for the life of the app.
class InMemorySessionStore implements SessionStore {
  AuthSession? _current;

  @override
  AuthSession? get current => _current;

  @override
  void save(AuthSession session) => _current = session;

  @override
  void clear() => _current = null;
}
