import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/features/auth/data/repositories/noop_biometric_authenticator.dart';

/// Wires the app on the mock backend with no latency, an in-memory secure
/// storage holding [secureValues] and an always-approving biometric check.
Future<void> configureTestDependencies({
  Map<String, String> secureValues = const {},
}) {
  FlutterSecureStorage.setMockInitialValues({...secureValues});
  return configureDependencies(
    latency: Duration.zero,
    secureStorage: const FlutterSecureStorage(),
    biometrics: const NoopBiometricAuthenticator(),
  );
}
