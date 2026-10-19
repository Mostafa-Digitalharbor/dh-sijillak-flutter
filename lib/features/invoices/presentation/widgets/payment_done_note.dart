import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_border_box.dart';
import '../constants/invoices_dimens.dart';

/// Dashed note that the linked deal was marked as won automatically.
class PaymentDoneNote extends StatelessWidget {
  const PaymentDoneNote({super.key});

  @override
  Widget build(BuildContext context) {
    return DashedBorderBox(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s12,
      ),
      fill: AppColors.white55,
      radius: AppRadius.r16,
      strokeWidth: AppSizes.borderThin,
      color: AppColors.borderDashed,
      contentBox: true,
      child: Row(
        children: [
          const AppIcon(
            AppIcons.funnel,
            size: InvoicesDimens.noteIconSize,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Text(
              context.l10n.dealAutoWon,
              style: AppTextStyles.caption.restyle(
                fontSize: InvoicesDimens.noteTextSize,
                color: AppColors.textStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
