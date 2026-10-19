import '../../domain/repositories/biometric_authenticator.dart';

/// Approves every request: stands in until a native biometric plugin is wired.
class NoopBiometricAuthenticator implements BiometricAuthenticator {
  const NoopBiometricAuthenticator();

  @override
  Future<bool> authenticate() async => true;
}
