import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/registration_draft.dart';
import '../entities/workspace.dart';
import '../repositories/auth_repository.dart';
import '../repositories/session_store.dart';

/// Submits the registration and signs the new owner in to the new workspace.
class RegisterWorkspaceUseCase
    implements UseCase<Workspace, RegistrationDraft> {
  const RegisterWorkspaceUseCase(this._repository, this._session);

  final AuthRepository _repository;
  final SessionStore _session;

  @override
  Future<Result<Workspace>> call(RegistrationDraft params) async {
    final result = await _repository.register(params);
    return result.when(
      success: (session) {
        _session.save(session);
        return Success(session.workspace);
      },
      error: Failed.new,
    );
  }
}
