import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../domain/repositories/biometric_authenticator.dart';
import '../../domain/usecases/login_with_biometrics_use_case.dart';

/// Shows why a sign-in failed; the biometric button gets its own messages
/// (nothing to resume, nothing enrolled, locked out), the rest the generic
/// one.
void showLoginFailureSnackBar(BuildContext context, Failure failure) {
  final l10n = context.l10n;
  final message = switch (failure) {
    ValidationFailure(:final fields)
        when fields[LoginWithBiometricsUseCase.noCredentialField] ==
            LoginWithBiometricsUseCase.noCredentialCode =>
      l10n.loginBiometricNeedsPassword,
    UnauthorizedFailure(message: BiometricErrors.unavailable) =>
      l10n.loginBiometricUnavailable,
    UnauthorizedFailure(message: BiometricErrors.lockedOut) =>
      l10n.loginBiometricLockedOut,
    _ => null,
  };
  if (message == null) return showFailureSnackBar(context, failure);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
