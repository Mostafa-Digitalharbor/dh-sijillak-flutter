import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/network/api_client.dart';
import 'package:sijilak/core/network/auth_tokens.dart';
import 'package:sijilak/core/network/http/http_api_client.dart';
import 'package:sijilak/core/network/session_events.dart';

import '../helpers/fake_http.dart';

const _stale = AuthTokens(accessToken: 'old', refreshToken: 'refresh-0');

class _Rig {
  _Rig(
    ResponseBody Function(RequestOptions) handler, {
    AuthTokens? tokens,
    FakeRefresher? refresher,
  }) : adapter = FakeAdapter(handler),
       storage = FakeTokenStorage(tokens),
       refresher = refresher ?? FakeRefresher(),
       events = SessionEvents() {
    api = HttpApiClient.create(
      baseUrl: 'https://api.test/',
      tokens: storage,
      events: events,
      languageCode: () => 'ar',
      refreshPath: '/auth/refresh',
      refresher: this.refresher,
      adapter: adapter,
      logging: false,
    );
    events.expired.listen((_) => expiredEvents++);
  }

  final FakeAdapter adapter;
  final FakeTokenStorage storage;
  final FakeRefresher refresher;
  final SessionEvents events;
  late final HttpApiClient api;
  int expiredEvents = 0;
}

ResponseBody _error(int status, [Object? error]) =>
    jsonResponse(error == null ? null : {'error': error}, status: status);

Future<void> _pumpEvents() => Future<void>.delayed(Duration.zero);

void main() {
  group('requests and envelope', () {
    test('base url gets the version prefix and unwraps data', () async {
      final rig = _Rig(
        (_) => jsonResponse({
          'data': {'id': '1'},
        }),
      );
      final data = await rig.api.get('/deals/1', query: {'q': 'x'});
      expect(data.asJson, {'id': '1'});
      final request = rig.adapter.requests.single;
      expect(request.uri.toString(), 'https://api.test/v1/deals/1?q=x');
      expect(request.method, 'GET');
    });

    test('lists come back as lists', () async {
      final rig = _Rig(
        (_) => jsonResponse({
          'data': [
            {'id': 'a'},
            {'id': 'b'},
          ],
        }),
      );
      expect((await rig.api.get('/deals')).asJsonList, hasLength(2));
    });

    test('write methods send JSON bodies', () async {
      final rig = _Rig((_) => jsonResponse({'data': <String, Object?>{}}));
      await rig.api.post('/a', body: {'x': 1});
      await rig.api.put('/a', body: {'x': 2});
      await rig.api.patch('/a', body: {'x': 3});
      await rig.api.delete('/a');
      final methods = rig.adapter.requests.map((r) => r.method).toList();
      expect(methods, ['POST', 'PUT', 'PATCH', 'DELETE']);
      expect(rig.adapter.requests.first.data, {'x': 1});
      expect(
        rig.adapter.requests.first.headers[Headers.contentTypeHeader],
        contains('application/json'),
      );
    });

    test('an empty body is a null payload', () async {
      final rig = _Rig((_) => jsonResponse(null, status: 204));
      expect(await rig.api.delete('/a'), isNull);
    });

    test(
      'sends the language and platform headers, no auth when signed out',
      () async {
        final rig = _Rig((_) => jsonResponse({'data': 1}));
        await rig.api.get('/a');
        final headers = rig.adapter.requests.single.headers;
        expect(headers['Accept-Language'], 'ar');
        expect(headers['X-App-Platform'], isNotEmpty);
        expect(headers.containsKey('Authorization'), isFalse);
      },
    );

    test('sends the bearer token when signed in', () async {
      final rig = _Rig(
        (_) => jsonResponse({'data': 1}),
        tokens: const AuthTokens(accessToken: 'abc', refreshToken: 'r'),
      );
      await rig.api.get('/a');
      expect(
        rig.adapter.requests.single.headers['Authorization'],
        'Bearer abc',
      );
    });

    test('joinBaseUrl trims slashes', () {
      expect(
        HttpApiClient.joinBaseUrl(' https://h.io// ', '/v1'),
        'https://h.io/v1',
      );
    });
  });

  group('error mapping', () {
    Future<Object> failure(
      ResponseBody Function(RequestOptions) handler,
    ) async {
      final rig = _Rig(handler);
      try {
        await rig.api.get('/a');
      } on AppException catch (error) {
        return error;
      }
      fail('expected an AppException');
    }

    test('404 -> NotFoundException', () async {
      expect(await failure((_) => _error(404)), isA<NotFoundException>());
    });

    test(
      '401 without a session -> UnauthorizedException, no refresh',
      () async {
        final rig = _Rig((_) => _error(401, {'message': 'bad'}));
        await expectLater(
          rig.api.get('/a'),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'bad',
            ),
          ),
        );
        expect(rig.refresher.usedTokens, isEmpty);
      },
    );

    test('422 -> ValidationException with fields', () async {
      final error = await failure(
        (_) => _error(422, {
          'code': 'validation',
          'message': 'Invalid',
          'fields': {
            'email': 'invalid',
            'phone': ['taken', 'other'],
          },
        }),
      );
      expect(error, isA<ValidationException>());
      expect((error as ValidationException).fields, {
        'email': 'invalid',
        'phone': 'taken',
      });
      expect(error.message, 'Invalid');
    });

    test('422 without a body is still a validation error', () async {
      expect(await failure((_) => _error(422)), isA<ValidationException>());
    });

    test('400 with fields -> ValidationException', () async {
      final error = await failure(
        (_) => _error(400, {
          'fields': {'handle': 'taken'},
        }),
      );
      expect((error as ValidationException).fields, {'handle': 'taken'});
    });

    test('400 without fields -> ServerException', () async {
      final error = await failure((_) => _error(400, {'code': 'bad_request'}));
      expect(error, isA<ServerException>());
      expect((error as ServerException).statusCode, 400);
      expect(error.code, 'bad_request');
    });

    test('5xx -> ServerException with status, code and message', () async {
      final error = await failure(
        (_) => _error(503, {'code': 'down', 'message': 'maintenance'}),
      );
      expect(error, isA<ServerException>());
      final server = error as ServerException;
      expect(server.statusCode, 503);
      expect(server.code, 'down');
      expect(server.message, 'maintenance');
    });

    test('a non-JSON error body still maps by status', () async {
      final error = await failure(
        (_) => ResponseBody.fromString('<html>boom</html>', 502),
      );
      expect((error as ServerException).statusCode, 502);
    });

    test('timeouts and connection errors -> NetworkException', () async {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        final error = await failure(
          (options) => throw DioException(requestOptions: options, type: type),
        );
        expect(error, isA<NetworkException>(), reason: type.name);
      }
    });
  });

  group('token refresh', () {
    ResponseBody Function(RequestOptions) expiredUntilRefreshed() =>
        (options) => options.headers['Authorization'] == 'Bearer old'
        ? _error(401)
        : jsonResponse({'data': 'ok'});

    test('401 -> refresh -> replay once with the new token', () async {
      final rig = _Rig(expiredUntilRefreshed(), tokens: _stale);
      expect(await rig.api.get('/a'), 'ok');
      expect(rig.refresher.usedTokens, ['refresh-0']);
      expect(rig.adapter.requests, hasLength(2));
      expect(
        rig.adapter.requests.last.headers['Authorization'],
        'Bearer access-1',
      );
      expect(rig.storage.tokens?.refreshToken, 'refresh-1');
      await _pumpEvents();
      expect(rig.expiredEvents, 0);
    });

    test('a replayed request that 401s again is not retried again', () async {
      final rig = _Rig((_) => _error(401), tokens: _stale);
      await expectLater(
        rig.api.get('/a'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(rig.refresher.usedTokens, hasLength(1));
      expect(rig.adapter.requests, hasLength(2));
    });

    test('concurrent 401s trigger a single refresh', () async {
      final rig = _Rig(expiredUntilRefreshed(), tokens: _stale);
      final results = await Future.wait([
        rig.api.get('/a'),
        rig.api.get('/b'),
        rig.api.get('/c'),
      ]);
      expect(results, ['ok', 'ok', 'ok']);
      expect(rig.refresher.usedTokens, hasLength(1));
    });

    test('a 401 for an already superseded token just replays', () async {
      late _Rig rig;
      rig = _Rig((options) {
        if (options.headers['Authorization'] != 'Bearer old') {
          return jsonResponse({'data': 'ok'});
        }
        // Another request renewed the pair while this one was in flight.
        rig.storage.tokens = const AuthTokens(
          accessToken: 'newer',
          refreshToken: 'refresh-9',
        );
        return _error(401);
      }, tokens: _stale);
      expect(await rig.api.get('/a'), 'ok');
      expect(rig.refresher.usedTokens, isEmpty);
      expect(
        rig.adapter.requests.last.headers['Authorization'],
        'Bearer newer',
      );
    });

    test('a rejected refresh clears the session and emits the event', () async {
      final rig = _Rig(
        expiredUntilRefreshed(),
        tokens: _stale,
        refresher: FakeRefresher(error: const UnauthorizedException()),
      );
      await expectLater(
        rig.api.get('/a'),
        throwsA(isA<UnauthorizedException>()),
      );
      await _pumpEvents();
      expect(rig.storage.invalidations, 1);
      expect(rig.storage.tokens, isNull);
      expect(rig.expiredEvents, 1);
    });

    test(
      'concurrent requests share one failed refresh and one event',
      () async {
        final rig = _Rig(
          expiredUntilRefreshed(),
          tokens: _stale,
          refresher: FakeRefresher(error: const UnauthorizedException()),
        );
        final results = await Future.wait([
          rig.api.get('/a').then<Object?>((v) => v, onError: (Object e) => e),
          rig.api.get('/b').then<Object?>((v) => v, onError: (Object e) => e),
        ]);
        expect(results, everyElement(isA<UnauthorizedException>()));
        await _pumpEvents();
        expect(rig.refresher.usedTokens, hasLength(1));
        expect(rig.expiredEvents, 1);
      },
    );

    test('a refresh that cannot complete keeps the session', () async {
      final rig = _Rig(
        expiredUntilRefreshed(),
        tokens: _stale,
        refresher: FakeRefresher(error: const NetworkException()),
      );
      await expectLater(rig.api.get('/a'), throwsA(isA<NetworkException>()));
      await _pumpEvents();
      expect(rig.storage.invalidations, 0);
      expect(rig.storage.tokens, _stale);
      expect(rig.expiredEvents, 0);
    });

    test('a 5xx during refresh keeps the session too', () async {
      final rig = _Rig(
        expiredUntilRefreshed(),
        tokens: _stale,
        refresher: FakeRefresher(error: const ServerException(statusCode: 500)),
      );
      await expectLater(rig.api.get('/a'), throwsA(isA<ServerException>()));
      expect(rig.storage.invalidations, 0);
    });
  });
}
