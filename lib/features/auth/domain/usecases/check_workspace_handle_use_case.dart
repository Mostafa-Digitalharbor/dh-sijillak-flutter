import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

/// Asks whether a workspace handle is still free (true) or taken (false).
class CheckWorkspaceHandleUseCase implements UseCase<bool, String> {
  const CheckWorkspaceHandleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<bool>> call(String handle) =>
      _repository.isHandleAvailable(handle);
}
