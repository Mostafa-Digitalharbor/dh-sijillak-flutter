import '../../../../core/network/auth_tokens.dart';
import '../../../../core/network/http/token_storage.dart';
import '../../domain/repositories/session_store.dart';

/// Lets the HTTP layer read and rotate the tokens held by the [SessionStore].
class SessionTokenStorage implements TokenStorage {
  const SessionTokenStorage(this._session);

  final SessionStore _session;

  @override
  AuthTokens? get tokens => _session.current?.tokens;

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    final current = _session.current;
    if (current != null) _session.save(current.withTokens(tokens));
  }

  @override
  Future<void> invalidate() async {
    _session
      ..clear()
      ..forgetRemembered();
  }
}
