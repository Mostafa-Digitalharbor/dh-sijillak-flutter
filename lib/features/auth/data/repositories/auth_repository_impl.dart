import '../../../../core/network/auth_tokens.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/otp_verification.dart';
import '../../domain/entities/registration_draft.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// [AuthRepository] backed by the auth API.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Result<bool>> isHandleAvailable(String handle) => Result.guard(
    () async => (await _remote.handleAvailability(handle)).toEntity(),
  );

  @override
  Future<Result<void>> requestOtp(String phone) =>
      Result.guard(() => _remote.requestOtp(phone));

  @override
  Future<Result<void>> verifyOtp(OtpVerification verification) =>
      Result.guard(() => _remote.verifyOtp(verification));

  @override
  Future<Result<AuthSession>> register(RegistrationDraft draft) =>
      Result.guard(() async => (await _remote.register(draft)).toEntity());

  @override
  Future<Result<AuthSession>> login(LoginCredentials credentials) =>
      Result.guard(() async => (await _remote.login(credentials)).toEntity());

  @override
  Future<Result<AuthTokens>> refreshTokens(String refreshToken) =>
      Result.guard(() => _remote.refresh(refreshToken));
}
