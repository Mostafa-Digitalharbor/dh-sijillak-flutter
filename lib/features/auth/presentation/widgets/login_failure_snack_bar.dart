import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../data/datasources/auth_api_fields.dart';

/// Shows why a sign-in failed; the "no earlier sign-in" case of the biometric
/// button gets its own message, the rest the generic one.
void showLoginFailureSnackBar(BuildContext context, Failure failure) {
  final noCredential =
      failure is ValidationFailure &&
      failure.fields[AuthApiFields.biometric] == AuthApiFields.noCredentialCode;
  if (!noCredential) return showFailureSnackBar(context, failure);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(context.l10n.loginBiometricNeedsPassword)),
    );
}
