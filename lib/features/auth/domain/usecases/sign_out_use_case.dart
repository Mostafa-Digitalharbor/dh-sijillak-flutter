import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/session_store.dart';

/// Signs out: forgets the signed-in session and its tokens (from secure
/// storage too). The remembered refresh token stays so the device can resume
/// with biometrics; it is dropped for good when the server rejects it.
class SignOutUseCase implements UseCase<void, NoParams> {
  const SignOutUseCase(this._session);

  final SessionStore _session;

  @override
  Future<Result<void>> call(NoParams params) async {
    _session.clear();
    return const Success(null);
  }
}
