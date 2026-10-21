import '../../domain/repositories/biometric_authenticator.dart';

/// Approves every request: for tests and platforms without biometrics.
class NoopBiometricAuthenticator implements BiometricAuthenticator {
  const NoopBiometricAuthenticator();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> authenticate() async => true;
}
