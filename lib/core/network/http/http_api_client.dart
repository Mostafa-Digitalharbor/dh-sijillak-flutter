// API conventions this client assumes. Backend team: please compare with the
// real service (the endpoint list is in docs/API_CONTRACT.md).
//
// * Base URL: `API_BASE_URL` + `AppConfig.apiVersionPrefix` (`/v1`), e.g.
//   `https://api.example.com/v1/auth/login`. JSON in, JSON out (UTF-8).
// * Success: 2xx with the body `{"data": <payload>}`. `<payload>` is an object,
//   an array or `{}`; an empty body (204) is accepted for write calls that
//   return nothing.
// * Auth: every request carries `Authorization: Bearer <accessToken>` once the
//   user is signed in. Tokens come from the sign-in / registration payload as
//   `"tokens": {"accessToken", "refreshToken", "expiresAt"(ISO-8601)}`.
// * Refresh: `POST /auth/refresh` with `{"refreshToken": "..."}` answers
//   `{"data": {"accessToken", "refreshToken", "expiresAt"}}` (rotating the
//   refresh token is allowed). On any 401 the app refreshes once, replays the
//   request once, and signs the user out when the refresh is rejected (any
//   4xx). Offline / 5xx during refresh keeps the session.
// * Errors: a non-2xx body is `{"error": {"code": "<machine_code>",
//   "message": "<text>", "fields": {"<field>": "<code>"}}}`; only the status
//   is required, the rest is best-effort. Mapping: 401 unauthorized, 404 not
//   found, 422 (or 400 with `fields`) validation (`fields` = field -> code),
//   everything else (incl. 403, 409, 429, 5xx) a server error carrying the
//   status and `error.code`. Timeouts / no connection are network errors.
// * Headers sent: `Accept-Language` (`ar` | `en`, the user's language),
//   `X-App-Platform` (android | iOS | ...), `Accept: application/json`.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/app_config.dart';
import '../api_client.dart';
import '../session_events.dart';
import 'api_error_mapper.dart';
import 'auth_interceptor.dart';
import 'language_interceptor.dart';
import 'redacting_log_interceptor.dart';
import 'response_envelope.dart';
import 'token_refresher.dart';
import 'token_storage.dart';

/// [ApiClient] that talks to the real backend over HTTP (see the conventions
/// above).
class HttpApiClient implements ApiClient {
  HttpApiClient(this._dio);

  /// Builds a client for [baseUrl] with the auth, language and (in debug
  /// builds) logging interceptors.
  ///
  /// [refreshPath] is the token-refresh endpoint; [refresher] defaults to an
  /// [ApiTokenRefresher] on a bare Dio. [adapter] replaces the network layer
  /// (tests).
  factory HttpApiClient.create({
    required String baseUrl,
    required TokenStorage tokens,
    required SessionEvents events,
    required String Function() languageCode,
    required String refreshPath,
    String versionPrefix = AppConfig.apiVersionPrefix,
    TokenRefresher? refresher,
    HttpClientAdapter? adapter,
    bool logging = kDebugMode,
  }) {
    final options = BaseOptions(
      baseUrl: joinBaseUrl(baseUrl, versionPrefix),
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: {Headers.acceptHeader: Headers.jsonContentType},
    );
    final dio = Dio(options);
    final bare = Dio(options);
    if (adapter != null) {
      dio.httpClientAdapter = adapter;
      bare.httpClientAdapter = adapter;
    }
    dio.interceptors.addAll([
      LanguageInterceptor(languageCode),
      AuthInterceptor(
        dio: dio,
        tokens: tokens,
        refresher: refresher ?? ApiTokenRefresher(bare, path: refreshPath),
        events: events,
      ),
      if (logging) RedactingLogInterceptor(),
    ]);
    return HttpApiClient(dio);
  }

  final Dio _dio;

  static final _trailingSlashes = RegExp(r'/+$');

  /// `https://host/` + `/v1` -> `https://host/v1`.
  static String joinBaseUrl(String baseUrl, String versionPrefix) {
    final root = baseUrl.trim().replaceAll(_trailingSlashes, '');
    return '$root$versionPrefix';
  }

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  @override
  Future<Object?> post(String path, {Json? body}) =>
      _send('POST', path, body: body);

  @override
  Future<Object?> put(String path, {Json? body}) =>
      _send('PUT', path, body: body);

  @override
  Future<Object?> patch(String path, {Json? body}) =>
      _send('PATCH', path, body: body);

  @override
  Future<Object?> delete(String path) => _send('DELETE', path);

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Json? body,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method),
      );
      return unwrapEnvelope(response.data);
    } on DioException catch (error) {
      throw ApiErrorMapper.map(error);
    }
  }
}
