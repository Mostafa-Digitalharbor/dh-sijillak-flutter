import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/customer_dimens.dart';

/// Small frosted tile with a caption and a bold figure.
class CustomerStatTile extends StatelessWidget {
  const CustomerStatTile({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.ink,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.white72,
        borderRadius: BorderRadius.circular(AppRadius.r18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.s4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              style: AppTextStyles.title.restyle(
                fontSize: CustomerDimens.statValueFont,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
