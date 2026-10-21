import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/network/auth_tokens.dart';
import 'package:sijilak/core/network/http/token_refresher.dart';
import 'package:sijilak/core/network/http/token_storage.dart';

/// A canned HTTP answer.
ResponseBody jsonResponse(Object? body, {int status = 200}) =>
    ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

/// Network layer that answers every request through [handler] and records it.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final FutureOr<ResponseBody> Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

/// In-memory [TokenStorage] that counts invalidations.
class FakeTokenStorage implements TokenStorage {
  FakeTokenStorage([this.tokens]);

  @override
  AuthTokens? tokens;
  int invalidations = 0;

  @override
  Future<void> saveTokens(AuthTokens tokens) async => this.tokens = tokens;

  @override
  Future<void> invalidate() async {
    invalidations++;
    tokens = null;
  }
}

/// [TokenRefresher] that hands out numbered pairs, or throws [error].
class FakeRefresher implements TokenRefresher {
  FakeRefresher({this.error, this.delay = const Duration(milliseconds: 20)});

  final AppException? error;
  final Duration delay;
  final List<String> usedTokens = [];

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    usedTokens.add(refreshToken);
    await Future<void>.delayed(delay);
    final failure = error;
    if (failure != null) throw failure;
    return AuthTokens(
      accessToken: 'access-${usedTokens.length}',
      refreshToken: 'refresh-${usedTokens.length}',
    );
  }
}
