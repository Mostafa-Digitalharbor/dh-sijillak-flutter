import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';

/// Small caption with a bold value underneath (dates, terms).
class LabelValue extends StatelessWidget {
  const LabelValue({super.key, required this.label, required this.value});

  static const double _valueSize = 14;

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.s2),
        Text(
          value,
          style: AppTextStyles.bodyBold.restyle(fontSize: _valueSize),
        ),
      ],
    );
  }
}
