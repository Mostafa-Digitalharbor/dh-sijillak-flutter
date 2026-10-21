import '../../../../core/network/api_client.dart';
import '../../../../core/network/auth_tokens.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/otp_verification.dart';
import '../../domain/entities/registration_draft.dart';
import '../models/auth_session_model.dart';
import '../models/handle_availability_model.dart';
import '../models/registration_request_model.dart';
import 'auth_api_fields.dart';
import 'auth_endpoints.dart';

/// Calls of the auth API.
abstract interface class AuthRemoteDataSource {
  Future<HandleAvailabilityModel> handleAvailability(String handle);

  Future<void> requestOtp(String phone);

  Future<void> verifyOtp(OtpVerification verification);

  Future<AuthSessionModel> register(RegistrationDraft draft);

  Future<AuthSessionModel> login(LoginCredentials credentials);

  Future<AuthTokens> refresh(String refreshToken);
}

/// [AuthRemoteDataSource] over an [ApiClient].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<HandleAvailabilityModel> handleAvailability(String handle) async {
    final data = await _api.get(
      AuthEndpoints.handleAvailability,
      query: {AuthApiFields.handle: handle},
    );
    return HandleAvailabilityModel.fromJson(data.asJson);
  }

  @override
  Future<void> requestOtp(String phone) async {
    await _api.post(
      AuthEndpoints.requestOtp,
      body: {AuthApiFields.phone: phone},
    );
  }

  @override
  Future<void> verifyOtp(OtpVerification verification) async {
    await _api.post(
      AuthEndpoints.verifyOtp,
      body: {
        AuthApiFields.phone: verification.phone,
        AuthApiFields.code: verification.code,
      },
    );
  }

  @override
  Future<AuthSessionModel> register(RegistrationDraft draft) async {
    final data = await _api.post(
      AuthEndpoints.workspaces,
      body: RegistrationRequestModel(draft).toJson(),
    );
    return AuthSessionModel.fromJson(data.asJson);
  }

  @override
  Future<AuthSessionModel> login(LoginCredentials credentials) async {
    final data = await _api.post(
      AuthEndpoints.login,
      body: {
        AuthApiFields.email: credentials.email,
        AuthApiFields.password: credentials.password,
      },
    );
    return AuthSessionModel.fromJson(data.asJson);
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final data = await _api.post(
      AuthEndpoints.refresh,
      body: {AuthApiFields.refreshToken: refreshToken},
    );
    return AuthTokens.fromJson(data.asJson);
  }
}
