import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../constants/auth_dimens.dart';

/// Small caption + compact text field, used for inline pairs of inputs.
class CompactLabeledField extends StatelessWidget {
  const CompactLabeledField({
    super.key,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.s4),
        AppTextField(
          hint: hint,
          keyboardType: keyboardType,
          onChanged: onChanged,
          height: AuthDimens.compactFieldHeight,
          fontSize: AuthDimens.compactFieldFont,
        ),
      ],
    );
  }
}
