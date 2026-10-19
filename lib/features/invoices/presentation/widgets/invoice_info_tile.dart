import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/label_value.dart';

/// Frosted tile showing one invoice setting (issue date, payment terms).
class InvoiceInfoTile extends StatelessWidget {
  const InvoiceInfoTile({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.white72,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: LabelValue(label: label, value: value),
    );
  }
}
