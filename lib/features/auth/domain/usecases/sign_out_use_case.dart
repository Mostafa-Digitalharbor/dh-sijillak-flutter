import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/session_store.dart';

/// Forgets the signed-in session.
class SignOutUseCase implements UseCase<void, NoParams> {
  const SignOutUseCase(this._session);

  final SessionStore _session;

  @override
  Future<Result<void>> call(NoParams params) async {
    _session.clear();
    return const Success(null);
  }
}
