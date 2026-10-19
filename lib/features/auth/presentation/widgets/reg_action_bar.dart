import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Pinned bottom CTA of the registration steps; can be disabled while a
/// request is in flight.
class RegActionBar extends StatelessWidget {
  const RegActionBar({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.s14,
        AppSpacing.gutter,
        AppSpacing.s34,
      ),
      child: PrimaryButton(
        label: label,
        enabled: enabled,
        onPressed: onPressed,
      ),
    );
  }
}
