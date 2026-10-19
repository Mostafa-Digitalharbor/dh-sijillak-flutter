import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/invoices_dimens.dart';

/// Coloured dot and caption of one segment of the invoices summary bar.
class InvoiceLegendItem extends StatelessWidget {
  const InvoiceLegendItem({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: InvoicesDimens.legendDot,
          height: InvoicesDimens.legendDot,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(InvoicesDimens.legendDotRadius),
          ),
        ),
        const SizedBox(width: AppSpacing.s5),
        Text(
          text,
          style: AppTextStyles.caption.restyle(color: AppColors.textStrong),
        ),
      ],
    );
  }
}
