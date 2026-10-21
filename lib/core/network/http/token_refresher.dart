import 'package:dio/dio.dart';

import '../api_client.dart';
import '../auth_tokens.dart';
import 'api_error_mapper.dart';
import 'response_envelope.dart';

/// Exchanges a refresh token for a new token pair.
abstract interface class TokenRefresher {
  /// Throws an `AppException`: `UnauthorizedException` (or another 4xx) when
  /// the refresh token is no longer accepted, `NetworkException` /
  /// `ServerException` when the attempt could not be completed.
  Future<AuthTokens> refresh(String refreshToken);
}

/// [TokenRefresher] over a bare [Dio] (no interceptors, so a failing refresh
/// can never trigger another refresh).
class ApiTokenRefresher implements TokenRefresher {
  const ApiTokenRefresher(this._dio, {required this.path});

  final Dio _dio;

  /// Endpoint, relative to the Dio base URL.
  final String path;

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    try {
      final response = await _dio.post<Object?>(
        path,
        data: {AuthTokens.refreshTokenKey: refreshToken},
      );
      return AuthTokens.fromJson(unwrapEnvelope(response.data).asJson);
    } on DioException catch (error) {
      throw ApiErrorMapper.map(error);
    }
  }
}
