import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// A form label above a custom field body (pickers, read-only boxes).
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.gap = AppSpacing.s6,
  });

  final String label;
  final Widget child;

  /// Space between the label and [child].
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        SizedBox(height: gap),
        child,
      ],
    );
  }
}
