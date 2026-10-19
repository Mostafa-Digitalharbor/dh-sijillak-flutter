import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/auth/data/repositories/noop_biometric_authenticator.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/entities/app_user.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/entities/login_credentials.dart';
import 'package:sijilak/features/auth/domain/entities/otp_verification.dart';
import 'package:sijilak/features/auth/domain/entities/registration_draft.dart';
import 'package:sijilak/features/auth/domain/entities/workspace.dart';
import 'package:sijilak/features/auth/domain/repositories/auth_repository.dart';
import 'package:sijilak/features/auth/domain/usecases/check_workspace_handle_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/login_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/login_with_biometrics_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/register_workspace_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/request_otp_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:sijilak/features/auth/presentation/cubit/account_cubit.dart';
import 'package:sijilak/features/auth/presentation/cubit/company_cubit.dart';
import 'package:sijilak/features/auth/presentation/cubit/login_cubit.dart';
import 'package:sijilak/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:sijilak/features/auth/presentation/cubit/registration_cubit.dart';

const _workspace = Workspace(
  id: 'w',
  name: 'Acme',
  handle: 'acme',
  url: 'acme.sijillak.com',
);
const _session = AuthSession(
  user: AppUser(id: 'u', name: 'Sara', email: 's@a.sa'),
  workspace: _workspace,
);

/// Hand-written repository: every call succeeds unless [failure] is set.
class _FakeRepository implements AuthRepository {
  _FakeRepository({this.failure, this.takenHandles = const {}});

  final Failure? failure;
  final Set<String> takenHandles;
  final List<String> checkedHandles = [];
  int otpRequests = 0;

  Result<T> _result<T>(T value) =>
      failure == null ? Success(value) : Failed(failure!);

  @override
  Future<Result<bool>> isHandleAvailable(String handle) async {
    checkedHandles.add(handle);
    return _result(!takenHandles.contains(handle));
  }

  @override
  Future<Result<void>> requestOtp(String phone) async {
    otpRequests++;
    return _result<void>(null);
  }

  @override
  Future<Result<void>> verifyOtp(OtpVerification verification) async =>
      _result<void>(null);

  @override
  Future<Result<AuthSession>> register(RegistrationDraft draft) async =>
      _result(_session);

  @override
  Future<Result<AuthSession>> login(LoginCredentials credentials) async =>
      _result(_session);

  @override
  Future<Result<AuthSession>> loginWithBiometrics() async => _result(_session);
}

/// Real-time wait that comfortably outlasts the cubits' 10 ms test debounce
/// even when the machine is busy running the whole suite.
Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 300));

OtpCubit _otpCubit(_FakeRepository repo, {int seconds = 60}) => OtpCubit(
  VerifyOtpUseCase(repo),
  ResendOtpUseCase(repo),
  phone: '500000000',
  resendSeconds: seconds,
  tick: const Duration(milliseconds: 5),
);

void main() {
  group('CompanyCubit', () {
    CompanyCubit build(_FakeRepository repo) => CompanyCubit(
      CheckWorkspaceHandleUseCase(repo),
      debounce: const Duration(milliseconds: 10),
    );

    test('cleans input and debounces a single availability check', () async {
      final repo = _FakeRepository();
      final cubit = build(repo);
      addTearDown(cubit.close);
      cubit
        ..handleChanged('A')
        ..handleChanged('Ac')
        ..handleChanged('Ac m!e');
      expect(cubit.state.handle, 'acme');
      expect(cubit.state.status, HandleStatus.checking);
      await _settle();
      expect(repo.checkedHandles, ['acme']);
      expect(cubit.state.status, HandleStatus.available);
    });

    test('reports a taken handle', () async {
      final cubit = build(_FakeRepository(takenHandles: {'admin'}));
      addTearDown(cubit.close);
      cubit.handleChanged('admin');
      await _settle();
      expect(cubit.state.status, HandleStatus.taken);
    });

    test('a failed check leaves the status unknown', () async {
      final cubit = build(_FakeRepository(failure: const NetworkFailure()));
      addTearDown(cubit.close);
      cubit.handleChanged('acme');
      await _settle();
      expect(cubit.state.status, HandleStatus.unknown);
    });

    test('clearing the field resets to empty with the sample preview', () {
      final cubit = build(_FakeRepository());
      addTearDown(cubit.close);
      cubit
        ..handleChanged('acme')
        ..handleChanged('');
      expect(cubit.state.status, HandleStatus.empty);
      expect(cubit.state.previewHandle, 'company');
    });
  });

  group('AccountCubit', () {
    test('rates passwords', () {
      expect(const AccountState().strength, PasswordStrength.none);
      expect(
        const AccountState(password: 'abc').strength,
        PasswordStrength.weak,
      );
      expect(
        const AccountState(password: 'abcdefg1').strength,
        PasswordStrength.medium,
      );
      expect(
        const AccountState(password: 'abcdefg1!').strength,
        PasswordStrength.strong,
      );
    });

    test('sendOtp succeeds through the use case', () async {
      final repo = _FakeRepository();
      final cubit = AccountCubit(RequestOtpUseCase(repo));
      addTearDown(cubit.close);
      cubit.passwordChanged('abc');
      await cubit.sendOtp('500000000');
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.password, 'abc');
      expect(repo.otpRequests, 1);
    });

    test('sendOtp failure is exposed', () async {
      final cubit = AccountCubit(
        RequestOtpUseCase(_FakeRepository(failure: const NetworkFailure())),
      );
      addTearDown(cubit.close);
      await cubit.sendOtp('500000000');
      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, isA<NetworkFailure>());
    });
  });

  group('OtpCubit', () {
    test('collects up to six digits and supports delete', () {
      final cubit = _otpCubit(_FakeRepository());
      addTearDown(cubit.close);
      for (final d in '1234567'.split('')) {
        cubit.digitPressed(d);
      }
      expect(cubit.state.code, '123456');
      expect(cubit.state.isComplete, isTrue);
      cubit.deletePressed();
      expect(cubit.state.code, '12345');
      expect(cubit.state.isComplete, isFalse);
    });

    test('verify succeeds only with a complete code', () async {
      final cubit = _otpCubit(_FakeRepository());
      addTearDown(cubit.close);
      await cubit.verify();
      expect(cubit.state.status, ViewStatus.initial);
      for (final d in '123456'.split('')) {
        cubit.digitPressed(d);
      }
      await cubit.verify();
      expect(cubit.state.status, ViewStatus.success);
    });

    test('verify failure is exposed and editing clears it', () async {
      final cubit = _otpCubit(
        _FakeRepository(failure: const ValidationFailure()),
      );
      addTearDown(cubit.close);
      for (final d in '000000'.split('')) {
        cubit.digitPressed(d);
      }
      await cubit.verify();
      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, isA<ValidationFailure>());
      cubit.deletePressed();
      expect(cubit.state.status, ViewStatus.initial);
      expect(cubit.state.failure, isNull);
    });

    test('cannot resend before the countdown ends', () async {
      final repo = _FakeRepository();
      final cubit = _otpCubit(repo);
      addTearDown(cubit.close);
      expect(cubit.state.canResend, isFalse);
      await cubit.resend();
      expect(repo.otpRequests, 0);
    });

    test('counts down, then resend restarts the countdown', () async {
      final repo = _FakeRepository();
      final cubit = _otpCubit(repo, seconds: 2);
      addTearDown(cubit.close);
      await _settle();
      expect(cubit.state.canResend, isTrue);
      await cubit.resend();
      expect(repo.otpRequests, 1);
      expect(cubit.state.secondsLeft, 2);
      expect(cubit.state.code, isEmpty);
    });
  });

  group('LoginCubit', () {
    test('signs in with the typed credentials', () async {
      final store = InMemorySessionStore();
      final repo = _FakeRepository();
      final cubit = LoginCubit(
        LoginUseCase(repo, store),
        LoginWithBiometricsUseCase(
          repo,
          const NoopBiometricAuthenticator(),
          store,
        ),
      );
      addTearDown(cubit.close);
      cubit
        ..emailChanged('s@a.sa')
        ..passwordChanged('pw');
      await cubit.signIn();
      expect(cubit.state.status, ViewStatus.success);
      expect(store.current, _session);
    });

    test('failure is exposed', () async {
      final repo = _FakeRepository(failure: const ValidationFailure());
      final store = InMemorySessionStore();
      final cubit = LoginCubit(
        LoginUseCase(repo, store),
        LoginWithBiometricsUseCase(
          repo,
          const NoopBiometricAuthenticator(),
          store,
        ),
      );
      addTearDown(cubit.close);
      await cubit.signIn();
      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, isA<ValidationFailure>());
    });
  });

  group('RegistrationCubit', () {
    RegistrationCubit build(_FakeRepository repo) => RegistrationCubit(
      RegisterWorkspaceUseCase(repo, InMemorySessionStore()),
    );

    test('steps write into the shared draft', () {
      final cubit = build(_FakeRepository());
      addTearDown(cubit.close);
      cubit
        ..edit((d) => d.copyWith(companyName: 'Acme'))
        ..edit((d) => d.copyWith(email: 's@a.sa'));
      expect(cubit.state.draft.companyName, 'Acme');
      expect(cubit.state.draft.email, 's@a.sa');
    });

    test('submit exposes the created workspace', () async {
      final cubit = build(_FakeRepository());
      addTearDown(cubit.close);
      await cubit.submit();
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.workspace, _workspace);
    });

    test('submit failure keeps the draft', () async {
      final cubit = build(_FakeRepository(failure: const ServerFailure()));
      addTearDown(cubit.close);
      cubit.edit((d) => d.copyWith(companyName: 'Acme'));
      await cubit.submit();
      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, isA<ServerFailure>());
      expect(cubit.state.draft.companyName, 'Acme');
      expect(cubit.state.workspace, isNull);
    });
  });
}
