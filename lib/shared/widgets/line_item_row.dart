import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';

/// One priced line of a quote or invoice: name and "qty × price" detail on the
/// start side, the line amount on the end side, hairline underneath.
class LineItemRow extends StatelessWidget {
  const LineItemRow({
    super.key,
    required this.name,
    required this.detail,
    required this.amount,
  });

  static const double _textSize = 14;

  final String name;
  final String detail;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderSoft,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyBold.restyle(fontSize: _textSize),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(detail, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            amount,
            style: AppTextStyles.bodyBold.restyle(
              fontSize: _textSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
