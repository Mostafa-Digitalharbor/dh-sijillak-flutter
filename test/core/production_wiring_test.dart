import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/app/widgets/session_expiry_listener.dart';
import 'package:sijilak/core/constants/app_config.dart';
import 'package:sijilak/core/error/crash_reporter.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/error/global_error_handlers.dart';
import 'package:sijilak/core/network/api_client.dart';
import 'package:sijilak/core/network/auth_tokens.dart';
import 'package:sijilak/core/network/http/http_api_client.dart';
import 'package:sijilak/core/network/http/redacting_log_interceptor.dart';
import 'package:sijilak/core/network/http/token_refresher.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/session_events.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/auth/data/repositories/local_auth_biometric_authenticator.dart';
import 'package:sijilak/features/auth/data/repositories/noop_biometric_authenticator.dart';
import 'package:sijilak/features/auth/data/repositories/secure_session_store.dart';
import 'package:sijilak/features/auth/domain/entities/app_user.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/entities/workspace.dart';
import 'package:sijilak/features/auth/domain/repositories/biometric_authenticator.dart';
import 'package:sijilak/features/auth/domain/repositories/session_store.dart';

import '../helpers/fake_http.dart';
import '../helpers/flow_helpers.dart';
import '../helpers/test_dependencies.dart';

const _session = AuthSession(
  user: AppUser(id: 'u', name: 'Sara', email: 's@a.sa'),
  workspace: Workspace(
    id: 'w',
    name: 'Acme',
    handle: 'acme',
    url: 'acme.sijillak.com',
  ),
  tokens: AuthTokens(accessToken: 'a', refreshToken: 'r'),
);

/// `LocalAuthentication` with scripted answers.
class _FakeLocalAuth extends LocalAuthentication {
  _FakeLocalAuth({
    this.supported = true,
    this.canCheck = true,
    this.result = true,
    this.error,
  });

  final bool supported;
  final bool canCheck;
  final bool result;
  final LocalAuthException? error;
  String? reasonShown;
  bool? biometricOnlyAsked;

  @override
  Future<bool> isDeviceSupported() async => supported;

  @override
  Future<bool> get canCheckBiometrics async => canCheck;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<Object?> authMessages = const [],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async {
    reasonShown = localizedReason;
    biometricOnlyAsked = biometricOnly;
    final failure = error;
    if (failure != null) throw failure;
    return result;
  }
}

LocalAuthBiometricAuthenticator _wrapper(_FakeLocalAuth auth) =>
    LocalAuthBiometricAuthenticator(auth, reason: () => 'because');

class _RecordingReporter implements CrashReporter {
  final List<Object> errors = [];
  final List<bool> fatals = [];
  String? user;

  @override
  void record(Object error, StackTrace? stack, {bool fatal = false}) {
    errors.add(error);
    fatals.add(fatal);
  }

  @override
  void setUser(String? id) => user = id;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppConfig.validateBackend', () {
    test('mock backend needs no url', () {
      expect(
        () => AppConfig.validateBackend(useMockBackend: true, apiBaseUrl: ''),
        returnsNormally,
      );
    });

    test('real backend without a url fails fast', () {
      for (final blank in ['', '   ']) {
        expect(
          () => AppConfig.validateBackend(
            useMockBackend: false,
            apiBaseUrl: blank,
          ),
          throwsStateError,
        );
      }
    });

    test('real backend with a url is fine', () {
      expect(
        () => AppConfig.validateBackend(
          useMockBackend: false,
          apiBaseUrl: 'https://api.test',
        ),
        returnsNormally,
      );
    });

    test('defaults keep the app on the mock backend', () {
      expect(AppConfig.useMockBackend, isTrue);
      expect(AppConfig.apiBaseUrl, isEmpty);
    });
  });

  group('dependency injection backend choice', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('mock backend by default', () async {
      await configureTestDependencies();
      expect(getIt<ApiClient>(), isA<MockApiClient>());
      expect(getIt<SessionStore>(), isA<SecureSessionStore>());
    });

    test('HTTP client when the real backend is selected', () async {
      await configureDependencies(
        useMockBackend: false,
        apiBaseUrl: 'https://api.test',
        secureStorage: const FlutterSecureStorage(),
      );
      expect(getIt<ApiClient>(), isA<HttpApiClient>());
      expect(
        getIt<BiometricAuthenticator>(),
        isA<LocalAuthBiometricAuthenticator>(),
      );
    });

    test('real backend without a url refuses to start', () async {
      await expectLater(
        configureDependencies(useMockBackend: false, apiBaseUrl: ''),
        throwsStateError,
      );
    });

    test('a test biometric authenticator can be injected', () async {
      await configureTestDependencies();
      expect(
        getIt<BiometricAuthenticator>(),
        isA<NoopBiometricAuthenticator>(),
      );
    });
  });

  group('LocalAuthBiometricAuthenticator', () {
    test('asks with the localised reason, biometrics only', () async {
      final auth = _FakeLocalAuth();
      expect(await _wrapper(auth).authenticate(), isTrue);
      expect(auth.reasonShown, 'because');
      expect(auth.biometricOnlyAsked, isTrue);
    });

    test('is unavailable without hardware support or biometrics', () async {
      expect(await _wrapper(_FakeLocalAuth()).isAvailable(), isTrue);
      expect(
        await _wrapper(_FakeLocalAuth(supported: false)).isAvailable(),
        isFalse,
      );
      expect(
        await _wrapper(_FakeLocalAuth(canCheck: false)).isAvailable(),
        isFalse,
      );
    });

    test('authenticating when unavailable throws unauthorized', () async {
      await expectLater(
        _wrapper(_FakeLocalAuth(canCheck: false)).authenticate(),
        throwsA(
          isA<UnauthorizedException>().having(
            (e) => e.message,
            'message',
            BiometricErrors.unavailable,
          ),
        ),
      );
    });

    test('a failed match is false', () async {
      expect(
        await _wrapper(_FakeLocalAuth(result: false)).authenticate(),
        isFalse,
      );
    });

    test('a cancelled prompt is false, not an error', () async {
      final auth = _FakeLocalAuth(
        error: const LocalAuthException(
          code: LocalAuthExceptionCode.userCanceled,
        ),
      );
      expect(await _wrapper(auth).authenticate(), isFalse);
    });

    test('lockouts and missing enrollment map to unauthorized', () async {
      for (final entry in {
        LocalAuthExceptionCode.biometricLockout: BiometricErrors.lockedOut,
        LocalAuthExceptionCode.temporaryLockout: BiometricErrors.lockedOut,
        LocalAuthExceptionCode.noBiometricsEnrolled:
            BiometricErrors.unavailable,
      }.entries) {
        final auth = _FakeLocalAuth(error: LocalAuthException(code: entry.key));
        await expectLater(
          _wrapper(auth).authenticate(),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              entry.value,
            ),
          ),
          reason: entry.key.name,
        );
      }
    });
  });

  group('ApiTokenRefresher', () {
    test('posts the refresh token and parses the new pair', () async {
      final adapter = FakeAdapter(
        (_) => jsonResponse({
          'data': {
            'accessToken': 'new-a',
            'refreshToken': 'new-r',
            'expiresAt': '2030-01-01T00:00:00.000Z',
          },
        }),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test/v1'))
        ..httpClientAdapter = adapter;
      final tokens = await ApiTokenRefresher(
        dio,
        path: '/auth/refresh',
      ).refresh('old-r');
      expect(tokens.accessToken, 'new-a');
      expect(tokens.expiresAt, DateTime.utc(2030));
      expect(adapter.requests.single.data, {'refreshToken': 'old-r'});
      expect(adapter.requests.single.path, '/auth/refresh');
    });

    test('a rejected token is an UnauthorizedException', () async {
      final adapter = FakeAdapter((_) => jsonResponse(null, status: 401));
      final dio = Dio()..httpClientAdapter = adapter;
      await expectLater(
        ApiTokenRefresher(dio, path: '/x').refresh('r'),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });

  group('RedactingLogInterceptor', () {
    test('never logs credentials', () async {
      final lines = <String>[];
      final adapter = FakeAdapter(
        (_) => jsonResponse({
          'data': {'accessToken': 'SECRET-ACCESS', 'refreshToken': 'SECRET-R'},
        }),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(RedactingLogInterceptor(log: lines.add));
      await dio.post<Object?>(
        '/auth/login',
        data: {'email': 'a@b.sa', 'password': 'hunter2', 'code': '123456'},
        options: Options(headers: {'Authorization': 'Bearer SECRET-TOKEN'}),
      );
      final log = lines.join('\n');
      expect(log, contains('/auth/login'));
      expect(log, contains('a@b.sa'));
      for (final secret in [
        'hunter2',
        'SECRET-TOKEN',
        'SECRET-ACCESS',
        'SECRET-R',
        '123456',
      ]) {
        expect(log, isNot(contains(secret)), reason: secret);
      }
    });
  });

  group('CrashReporter', () {
    test('global handlers forward framework and platform errors', () {
      final reporter = _RecordingReporter();
      final oldFlutter = FlutterError.onError;
      final oldPlatform = PlatformDispatcher.instance.onError;
      final oldBuilder = ErrorWidget.builder;
      addTearDown(() {
        FlutterError.onError = oldFlutter;
        PlatformDispatcher.instance.onError = oldPlatform;
        ErrorWidget.builder = oldBuilder;
      });
      installGlobalErrorHandlers(reporter);
      final handled = PlatformDispatcher.instance.onError!(
        StateError('async'),
        StackTrace.current,
      );
      expect(handled, isTrue);
      expect(reporter.errors.single, isA<StateError>());
      expect(reporter.fatals.single, isTrue);
    });

    test('the console reporter never throws', () {
      const reporter = ConsoleCrashReporter();
      expect(() {
        reporter
          ..record(StateError('x'), StackTrace.current)
          ..setUser('u')
          ..setUser(null);
      }, returnsNormally);
    });

    testWidgets('the friendly error widget needs no theme', (tester) async {
      await tester.pumpWidget(const FriendlyErrorWidget());
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('session expiry', () {
    testWidgets('the listener calls back for every expiry event', (
      tester,
    ) async {
      final events = SessionEvents();
      addTearDown(events.dispose);
      var calls = 0;
      await tester.pumpWidget(
        SessionExpiryListener(
          events: events,
          onExpired: () => calls++,
          child: const SizedBox(),
        ),
      );
      events
        ..notifyExpired()
        ..notifyExpired();
      await tester.pump();
      expect(calls, 2);
      await tester.pumpWidget(const SizedBox());
      events.notifyExpired();
      await tester.pump();
      expect(calls, 2);
    });

    testWidgets('an expired session sends the app back to welcome', (
      tester,
    ) async {
      await bootApp(tester);
      final store = getIt<SessionStore>();
      store.save(_session);
      appRouter.go(AppRoutes.home);
      await settle(tester);
      expect(_location(), AppRoutes.home);

      store.clear();
      getIt<SessionEvents>().notifyExpired();
      await settle(tester);
      expect(_location(), AppRoutes.welcome);
    });
  });
}

String _location() => appRouter.routerDelegate.currentConfiguration.uri.path;
