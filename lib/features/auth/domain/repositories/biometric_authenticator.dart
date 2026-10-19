/// Asks the device to confirm the user's identity (Face ID, fingerprint...).
///
/// The single seam for biometrics: a `local_auth` implementation replaces
/// the registered one without touching any caller.
abstract interface class BiometricAuthenticator {
  /// Whether the user passed the device check.
  Future<bool> authenticate();
}
