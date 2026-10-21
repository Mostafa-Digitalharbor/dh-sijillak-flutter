import 'package:local_auth/local_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/biometric_authenticator.dart';

/// [BiometricAuthenticator] over the device `local_auth` plugin.
class LocalAuthBiometricAuthenticator implements BiometricAuthenticator {
  const LocalAuthBiometricAuthenticator(
    this._localAuth, {
    required this._reason,
  });

  final LocalAuthentication _localAuth;

  /// The localised sentence the system prompt shows.
  final String Function() _reason;

  /// Outcomes that mean "the user did not authenticate", not a fault.
  static const _declined = {
    LocalAuthExceptionCode.userCanceled,
    LocalAuthExceptionCode.systemCanceled,
    LocalAuthExceptionCode.timeout,
    LocalAuthExceptionCode.userRequestedFallback,
    LocalAuthExceptionCode.authInProgress,
    LocalAuthExceptionCode.uiUnavailable,
  };

  static const _lockedOut = {
    LocalAuthExceptionCode.temporaryLockout,
    LocalAuthExceptionCode.biometricLockout,
  };

  @override
  Future<bool> isAvailable() async {
    try {
      return await _localAuth.isDeviceSupported() &&
          await _localAuth.canCheckBiometrics;
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    if (!await isAvailable()) {
      throw const UnauthorizedException(BiometricErrors.unavailable);
    }
    try {
      return await _localAuth.authenticate(
        localizedReason: _reason(),
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (error) {
      if (_declined.contains(error.code)) return false;
      throw UnauthorizedException(
        _lockedOut.contains(error.code)
            ? BiometricErrors.lockedOut
            : BiometricErrors.unavailable,
      );
    }
  }
}
