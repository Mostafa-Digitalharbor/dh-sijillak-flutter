import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import 'primary_button.dart';

/// Pinned bottom CTA used by the registration steps.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.s14,
        AppSpacing.gutter,
        AppSpacing.s34,
      ),
      child: PrimaryButton(label: label, onPressed: onPressed),
    );
  }
}
