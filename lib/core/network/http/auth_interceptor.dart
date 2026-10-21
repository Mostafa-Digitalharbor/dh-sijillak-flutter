import 'dart:async';

import 'package:dio/dio.dart';

import '../../error/exceptions.dart';
import '../auth_tokens.dart';
import '../session_events.dart';
import 'token_refresher.dart';
import 'token_storage.dart';

/// Signs requests with the access token and recovers from an expired one.
///
/// On a 401 for a request that carried a token it refreshes the pair once
/// (concurrent 401s share one refresh), then replays the request a single
/// time. When the refresh token itself is rejected the stored credentials are
/// dropped and [SessionEvents.expired] fires; a refresh that merely failed to
/// complete (offline, 5xx) keeps the session and surfaces that error.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._dio,
    required this._tokens,
    required this._refresher,
    required this._events,
  });

  static const authorizationHeader = 'Authorization';
  static const bearerPrefix = 'Bearer ';
  static const _retriedKey = 'authRetried';
  static const _unauthorized = 401;

  final Dio _dio;
  final TokenStorage _tokens;
  final TokenRefresher _refresher;
  final SessionEvents _events;

  Future<void>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.tokens?.accessToken;
    if (token != null) {
      options.headers[authorizationHeader] = '$bearerPrefix$token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final sentToken = _sentToken(request);
    if (err.response?.statusCode != _unauthorized ||
        sentToken == null ||
        request.extra[_retriedKey] == true) {
      return handler.next(err);
    }
    try {
      // Another request may already have renewed the pair meanwhile.
      if (_tokens.tokens?.accessToken == sentToken) await _refreshOnce();
    } on AppException catch (error) {
      return handler.next(err.copyWith(error: error));
    }
    if (_tokens.tokens == null) return handler.next(err);
    try {
      final response = await _dio.fetch<Object?>(
        request.copyWith(extra: {...request.extra, _retriedKey: true}),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  String? _sentToken(RequestOptions request) {
    final header = request.headers[authorizationHeader];
    if (header is! String || !header.startsWith(bearerPrefix)) return null;
    return header.substring(bearerPrefix.length);
  }

  Future<void> _refreshOnce() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<void> _refresh() async {
    final current = _tokens.tokens;
    if (current == null) throw const UnauthorizedException();
    final AuthTokens renewed;
    try {
      renewed = await _refresher.refresh(current.refreshToken);
    } on NetworkException {
      rethrow;
    } on ServerException catch (error) {
      final status = error.statusCode;
      if (status == null || status >= 500) rethrow;
      await _expire();
      throw const UnauthorizedException();
    } on AppException {
      await _expire();
      throw const UnauthorizedException();
    }
    await _tokens.saveTokens(renewed);
  }

  Future<void> _expire() async {
    await _tokens.invalidate();
    _events.notifyExpired();
  }
}
