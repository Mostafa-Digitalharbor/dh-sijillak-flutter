import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../repositories/biometric_authenticator.dart';
import '../repositories/session_store.dart';

/// Signs in again after a successful device check, using the refresh token
/// remembered from the last sign-in.
class LoginWithBiometricsUseCase implements UseCase<AuthSession, NoParams> {
  const LoginWithBiometricsUseCase(
    this._repository,
    this._authenticator,
    this._session,
  );

  /// Field and code of the validation failure raised when there is no earlier
  /// sign-in to resume.
  static const noCredentialField = 'biometric';
  static const noCredentialCode = 'no_credential';

  final AuthRepository _repository;
  final BiometricAuthenticator _authenticator;
  final SessionStore _session;

  @override
  Future<Result<AuthSession>> call(NoParams params) async {
    final remembered = _session.remembered;
    final refreshToken = remembered?.tokens?.refreshToken;
    if (remembered == null || refreshToken == null) {
      return const Failed(
        ValidationFailure(fields: {noCredentialField: noCredentialCode}),
      );
    }
    final bool approved;
    try {
      approved = await _authenticator.authenticate();
    } on AppException catch (error) {
      return Failed(Failure.from(error));
    }
    if (!approved) return const Failed(UnauthorizedFailure());
    final result = await _repository.refreshTokens(refreshToken);
    return result.when(
      success: (tokens) {
        final session = remembered.withTokens(tokens);
        _session.save(session);
        return Success(session);
      },
      error: (failure) {
        if (failure is UnauthorizedFailure) _session.forgetRemembered();
        return Failed(failure);
      },
    );
  }
}
