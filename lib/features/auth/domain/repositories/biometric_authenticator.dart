/// Asks the device to confirm the user's identity (Face ID, fingerprint...).
///
/// The single seam for biometrics: the registered implementation can be
/// swapped without touching any caller.
abstract interface class BiometricAuthenticator {
  /// Whether the device has biometric hardware this app may use.
  Future<bool> isAvailable();

  /// Whether the user passed the device check. A cancelled prompt is `false`.
  ///
  /// Throws `UnauthorizedException` whose message is one of the
  /// [BiometricErrors] codes when the check cannot run at all.
  Future<bool> authenticate();
}

/// Machine-readable reasons carried by the exception of a check that could
/// not run.
abstract final class BiometricErrors {
  /// Nothing is enrolled, or the device has no usable biometric hardware.
  static const unavailable = 'biometric_unavailable';

  /// Too many failed attempts; try again later or unlock the device.
  static const lockedOut = 'biometric_locked_out';
}
