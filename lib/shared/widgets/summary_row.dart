import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';

/// Muted label on the start side, bold value on the end side (subtotal, VAT).
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, required this.value});

  static const double _textSize = 14;

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.subtitle.restyle(
              fontSize: _textSize,
              color: AppColors.textSubtle,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Text(value, style: AppTextStyles.bodyBold.restyle(fontSize: _textSize)),
      ],
    );
  }
}
