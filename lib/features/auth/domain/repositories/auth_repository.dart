import '../../../../core/network/auth_tokens.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../entities/login_credentials.dart';
import '../entities/otp_verification.dart';
import '../entities/registration_draft.dart';

/// Authentication and workspace registration.
abstract interface class AuthRepository {
  /// Whether [handle] can still be claimed.
  Future<Result<bool>> isHandleAvailable(String handle);

  Future<Result<void>> requestOtp(String phone);

  Future<Result<void>> verifyOtp(OtpVerification verification);

  /// Creates the workspace and its owner from the collected [draft].
  Future<Result<AuthSession>> register(RegistrationDraft draft);

  Future<Result<AuthSession>> login(LoginCredentials credentials);

  /// Exchanges [refreshToken] for a new token pair (the old one is rotated
  /// out). Fails with `UnauthorizedFailure` when it is no longer accepted.
  Future<Result<AuthTokens>> refreshTokens(String refreshToken);
}
