import 'package:equatable/equatable.dart';

import 'api_client.dart';

/// The credentials the backend issues at sign-in and rotates on refresh.
class AuthTokens extends Equatable {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  factory AuthTokens.fromJson(Json json) => AuthTokens(
    accessToken: json[accessTokenKey] as String,
    refreshToken: json[refreshTokenKey] as String,
    expiresAt: DateTime.tryParse(json[expiresAtKey] as String? ?? ''),
  );

  /// JSON keys, shared by every payload that carries tokens.
  static const accessTokenKey = 'accessToken';
  static const refreshTokenKey = 'refreshToken';
  static const expiresAtKey = 'expiresAt';

  /// Short-lived bearer token sent with every request.
  final String accessToken;

  /// Long-lived token exchanged for a new pair; also unlocks biometric
  /// sign-in.
  final String refreshToken;

  /// When [accessToken] stops being valid, when the backend says so.
  final DateTime? expiresAt;

  Json toJson() => {
    accessTokenKey: accessToken,
    refreshTokenKey: refreshToken,
    if (expiresAt != null) expiresAtKey: expiresAt!.toIso8601String(),
  };

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}
