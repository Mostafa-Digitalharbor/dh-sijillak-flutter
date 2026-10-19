import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../repositories/session_store.dart';

/// The remembered session, or null when nobody is signed in.
class GetSessionUseCase implements UseCase<AuthSession?, NoParams> {
  const GetSessionUseCase(this._session);

  final SessionStore _session;

  @override
  Future<Result<AuthSession?>> call(NoParams params) async =>
      Success(_session.current);
}
