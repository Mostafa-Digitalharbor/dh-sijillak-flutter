import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/auth/data/datasources/auth_api_fields.dart';
import 'package:sijilak/features/auth/data/datasources/auth_mock_api.dart';
import 'package:sijilak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sijilak/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sijilak/features/auth/data/repositories/noop_biometric_authenticator.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/entities/login_credentials.dart';
import 'package:sijilak/features/auth/domain/repositories/biometric_authenticator.dart';
import 'package:sijilak/features/auth/domain/usecases/login_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/login_with_biometrics_use_case.dart';
import 'package:sijilak/features/auth/presentation/cubit/login_cubit.dart';

class _Denying implements BiometricAuthenticator {
  @override
  Future<bool> authenticate() async => false;
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
        (failure! as ValidationFailure).fields[AuthApiFields.biometric],
        AuthApiFields.noCredentialCode,
      );
      expect(session.current, isNull);
    });

    test('signs in with the session of an earlier sign-in', () async {
      await passwordSignIn();
      final result = await biometric()(const NoParams());
      expect(result.dataOrNull?.user.email, 'a@b.sa');
      expect(session.current, result.dataOrNull);
    });

    test('a denied device check leaves no session', () async {
      await passwordSignIn();
      final result = await biometric(_Denying())(const NoParams());
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(session.current, isNull);
    });
  });

  group('LoginCubit biometrics', () {
    LoginCubit build() =>
        LoginCubit(LoginUseCase(repository, session), biometric());

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
