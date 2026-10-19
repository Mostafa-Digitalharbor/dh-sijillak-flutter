import 'package:flutter/material.dart';

import '../../core/error/failure.dart';
import '../../core/l10n/failure_l10n.dart';
import '../../core/l10n/l10n.dart';

/// Shows [failure]'s localised message in a snack bar.
void showFailureSnackBar(BuildContext context, Failure failure) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failure.localized(context.l10n))));
}
