import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/constants/app_config.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/features/auth/data/datasources/auth_mock_api.dart';
import 'package:sijilak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sijilak/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/entities/login_credentials.dart';
import 'package:sijilak/features/auth/domain/entities/otp_verification.dart';
import 'package:sijilak/features/auth/domain/entities/registration_draft.dart';
import 'package:sijilak/features/auth/domain/usecases/check_workspace_handle_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/login_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/register_workspace_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/verify_otp_use_case.dart';

/// Use cases over the real repository, data source and mock backend.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemorySessionStore session;
  late AuthRepositoryImpl repository;

  setUp(() {
    session = InMemorySessionStore();
    final api = MockApiClient(modules: [AuthMockApi(MockAssets())]);
    repository = AuthRepositoryImpl(AuthRemoteDataSourceImpl(api));
  });

  group('CheckWorkspaceHandleUseCase', () {
    test('free handle is available', () async {
      final result = await CheckWorkspaceHandleUseCase(repository)('acme');
      expect(result.dataOrNull, isTrue);
    });

    test('reserved handles are taken', () async {
      final check = CheckWorkspaceHandleUseCase(repository);
      for (final handle in AppConfig.reservedHandles) {
        expect((await check(handle)).dataOrNull, isFalse, reason: handle);
      }
    });
  });

  group('OTP use cases', () {
    test('request and resend succeed', () async {
      expect(
        (await RequestOtpUseCase(repository)('500000000')).isSuccess,
        true,
      );
      expect((await ResendOtpUseCase(repository)('500000000')).isSuccess, true);
    });

    test('any six digits verify', () async {
      final result = await VerifyOtpUseCase(repository)(
        const OtpVerification(phone: '500000000', code: '123456'),
      );
      expect(result.isSuccess, isTrue);
    });

    test('000000 and malformed codes are validation failures', () async {
      final verify = VerifyOtpUseCase(repository);
      for (final code in ['000000', '123', '12345a']) {
        final result = await verify(
          OtpVerification(phone: '500000000', code: code),
        );
        expect(result.failureOrNull, isA<ValidationFailure>(), reason: code);
      }
    });
  });

  group('LoginUseCase', () {
    test('non-empty credentials sign in and fill the session', () async {
      final result = await LoginUseCase(repository, session)(
        const LoginCredentials(email: 'a@b.sa', password: 'x'),
      );
      expect(result.dataOrNull?.user.email, 'a@b.sa');
      expect(session.current, result.dataOrNull);
    });

    test('empty credentials fail validation and leave no session', () async {
      final result = await LoginUseCase(repository, session)(
        const LoginCredentials(email: '', password: ''),
      );
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(session.current, isNull);
    });
  });

  group('RegisterWorkspaceUseCase', () {
    const draft = RegistrationDraft(
      companyName: 'Acme',
      handle: 'acme',
      ownerName: 'Sara',
      email: 'sara@acme.sa',
    );

    test('returns the created workspace and stores the session', () async {
      final result = await RegisterWorkspaceUseCase(repository, session)(draft);
      final workspace = result.dataOrNull!;
      expect(workspace.handle, 'acme');
      expect(workspace.name, 'Acme');
      expect(workspace.url, AppConfig.workspaceUrl('acme'));
      expect(session.current?.workspace, workspace);
      expect(session.current?.user.name, 'Sara');
    });

    test('a claimed handle is no longer available nor registrable', () async {
      final register = RegisterWorkspaceUseCase(repository, session);
      await register(draft);
      expect(
        (await CheckWorkspaceHandleUseCase(repository)('acme')).dataOrNull,
        isFalse,
      );
      expect((await register(draft)).failureOrNull, isA<ValidationFailure>());
    });

    test('a reserved handle is rejected', () async {
      final result = await RegisterWorkspaceUseCase(repository, session)(
        draft.copyWith(handle: 'admin'),
      );
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(session.current, isNull);
    });
  });
}
