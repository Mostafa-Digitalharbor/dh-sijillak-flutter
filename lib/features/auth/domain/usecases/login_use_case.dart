import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../entities/login_credentials.dart';
import '../repositories/auth_repository.dart';
import '../repositories/session_store.dart';

/// Signs in and remembers the session.
class LoginUseCase implements UseCase<AuthSession, LoginCredentials> {
  const LoginUseCase(this._repository, this._session);

  final AuthRepository _repository;
  final SessionStore _session;

  @override
  Future<Result<AuthSession>> call(LoginCredentials params) async {
    final result = await _repository.login(params);
    return result.when(
      success: (session) {
        _session.save(session);
        return Success(session);
      },
      error: Failed.new,
    );
  }
}
