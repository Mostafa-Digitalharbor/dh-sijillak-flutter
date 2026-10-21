/// Paths of the auth API.
abstract final class AuthEndpoints {
  static const handleAvailability = '/auth/handles/availability';
  static const requestOtp = '/auth/otp/request';
  static const verifyOtp = '/auth/otp/verify';
  static const workspaces = '/auth/workspaces';
  static const login = '/auth/login';
  static const refresh = '/auth/refresh';
}
