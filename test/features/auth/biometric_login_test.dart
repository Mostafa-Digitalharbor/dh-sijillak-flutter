import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/auth/data/datasources/auth_mock_api.dart';
import 'package:sijilak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sijilak/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sijilak/features/auth/data/repositories/noop_biometric_authenticator.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/entities/login_credentials.dart';
import 'package:sijilak/features/auth/domain/repositories/biometric_authenticator.dart';
import 'package:sijilak/features/auth/domain/usecases/can_use_biometrics_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/login_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/login_with_biometrics_use_case.dart';
import 'package:sijilak/features/auth/presentation/cubit/login_cubit.dart';

class _Denying implements BiometricAuthenticator {
  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> authenticate() async => false;
}

class _Unavailable implements BiometricAuthenticator {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<bool> authenticate() async =>
      throw const UnauthorizedException(BiometricErrors.unavailable);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemorySessionStore session;
  late AuthRepositoryImpl repository;

  setUp(() {
    session = InMemorySessionStore();
    final api = MockApiClient(modules: [AuthMockApi(MockAssets())]);
    repository = AuthRepositoryImpl(AuthRemoteDataSourceImpl(api));
  });

  LoginWithBiometricsUseCase biometric([BiometricAuthenticator? auth]) =>
      LoginWithBiometricsUseCase(
        repository,
        auth ?? const NoopBiometricAuthenticator(),
        session,
      );

  Future<void> passwordSignIn() async {
    await LoginUseCase(repository, session)(
      const LoginCredentials(email: 'a@b.sa', password: 'x'),
    );
    session.clear();
  }

  group('LoginWithBiometricsUseCase', () {
    test('fails before any password sign-in', () async {
      final failure = (await biometric()(const NoParams())).failureOrNull;
      expect(failure, isA<ValidationFailure>());
      expect(
        (failure! as ValidationFailure).fields[LoginWithBiometricsUseCase
            .noCredentialField],
        LoginWithBiometricsUseCase.noCredentialCode,
      );
      expect(session.current, isNull);
    });

    test('resumes the remembered session with its refresh token', () async {
      await passwordSignIn();
      final oldTokens = session.remembered!.tokens!;
      final result = await biometric()(const NoParams());
      final signedIn = result.dataOrNull!;
      expect(signedIn.user.email, 'a@b.sa');
      expect(signedIn.tokens, isNotNull);
      expect(signedIn.tokens!.refreshToken, isNot(oldTokens.refreshToken));
      expect(session.current, signedIn);
      expect(session.remembered, signedIn);
    });

    test('a refresh token can be used only once', () async {
      await passwordSignIn();
      final stale = session.remembered!;
      await biometric()(const NoParams());
      session
        ..clear()
        ..save(stale)
        ..clear();
      final result = await biometric()(const NoParams());
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(session.remembered, isNull);
    });

    test('a denied device check leaves no session', () async {
      await passwordSignIn();
      final result = await biometric(_Denying())(const NoParams());
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(session.current, isNull);
    });

    test('a check that cannot run reports why', () async {
      await passwordSignIn();
      final result = await biometric(_Unavailable())(const NoParams());
      expect(
        result.failureOrNull,
        const UnauthorizedFailure(BiometricErrors.unavailable),
      );
    });
  });

  group('CanUseBiometricsUseCase', () {
    test('mirrors the device', () async {
      expect(
        (await const CanUseBiometricsUseCase(NoopBiometricAuthenticator())(
          const NoParams(),
        )).dataOrNull,
        isTrue,
      );
      expect(
        (await CanUseBiometricsUseCase(_Unavailable())(const NoParams()))
            .dataOrNull,
        isFalse,
      );
    });
  });

  group('LoginCubit biometrics', () {
    LoginCubit build([BiometricAuthenticator? auth]) => LoginCubit(
      LoginUseCase(repository, session),
      biometric(auth),
      CanUseBiometricsUseCase(auth ?? const NoopBiometricAuthenticator()),
    );

    test('availability is loaded from the device', () async {
      final yes = build();
      final no = build(_Unavailable());
      addTearDown(yes.close);
      addTearDown(no.close);
      expect(yes.state.biometricsAvailable, isFalse);
      await yes.loadBiometricAvailability();
      await no.loadBiometricAvailability();
      expect(yes.state.biometricsAvailable, isTrue);
      expect(no.state.biometricsAvailable, isFalse);
    });

    test('failure is exposed after loading', () async {
      final cubit = build();
      addTearDown(cubit.close);
      final statuses = <ViewStatus>[];
      cubit.stream.listen((s) => statuses.add(s.status));
      await cubit.signInWithBiometrics();
      await Future<void>.delayed(Duration.zero);
      expect(statuses, [ViewStatus.loading, ViewStatus.failure]);
      expect(cubit.state.failure, isA<ValidationFailure>());
    });

    test('succeeds once a password sign-in happened', () async {
      final cubit = build();
      addTearDown(cubit.close);
      cubit
        ..emailChanged('a@b.sa')
        ..passwordChanged('x');
      await cubit.signIn();
      session.clear();
      await cubit.signInWithBiometrics();
      expect(cubit.state.status, ViewStatus.success);
      expect(session.current, isNotNull);
    });
  });
}
