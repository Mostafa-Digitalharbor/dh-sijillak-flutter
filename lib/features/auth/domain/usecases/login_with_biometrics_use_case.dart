import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../repositories/biometric_authenticator.dart';
import '../repositories/session_store.dart';

/// Signs in after a successful device check and remembers the session.
class LoginWithBiometricsUseCase implements UseCase<AuthSession, NoParams> {
  const LoginWithBiometricsUseCase(
    this._repository,
    this._authenticator,
    this._session,
  );

  final AuthRepository _repository;
  final BiometricAuthenticator _authenticator;
  final SessionStore _session;

  @override
  Future<Result<AuthSession>> call(NoParams params) async {
    if (!await _authenticator.authenticate()) {
      return const Failed(UnauthorizedFailure());
    }
    final result = await _repository.loginWithBiometrics();
    return result.when(
      success: (session) {
        _session.save(session);
        return Success(session);
      },
      error: Failed.new,
    );
  }
}
