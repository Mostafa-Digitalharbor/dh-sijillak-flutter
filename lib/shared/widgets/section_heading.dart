import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Large screen title with an optional subtitle underneath.
class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(subtitle!, style: AppTextStyles.subtitle),
        ],
      ],
    );
  }
}
