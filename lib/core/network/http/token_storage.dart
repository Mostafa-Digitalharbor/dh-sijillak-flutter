import '../auth_tokens.dart';

/// Where the HTTP layer reads and writes the credentials of the signed-in
/// user. Implemented over the session store by the auth feature.
abstract interface class TokenStorage {
  /// The current credentials, or null when signed out.
  AuthTokens? get tokens;

  /// Stores a refreshed pair.
  Future<void> saveTokens(AuthTokens tokens);

  /// Drops every credential: the server rejected them for good.
  Future<void> invalidate();
}
