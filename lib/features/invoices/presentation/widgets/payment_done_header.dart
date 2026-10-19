import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/invoices_dimens.dart';

/// Success badge, "payment recorded" title and the amount received.
class PaymentDoneHeader extends StatelessWidget {
  const PaymentDoneHeader({super.key, required this.amount});

  final num amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: InvoicesDimens.checkCircle,
          height: InvoicesDimens.checkCircle,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: InvoicesDimens.checkShadow,
          ),
          child: const Center(
            child: AppIcon(
              AppIcons.check,
              size: InvoicesDimens.checkIcon,
              color: Colors.white,
              strokeWidth: InvoicesDimens.checkIconStroke,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(
          context.l10n.paymentRecorded,
          textAlign: TextAlign.center,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.s12),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                context.amount(amount),
                style: AppTextStyles.titleLarge.restyle(
                  fontSize: InvoicesDimens.doneAmountSize,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Text(
                context.l10n.sar,
                style: AppTextStyles.subtitle.restyle(
                  fontSize: InvoicesDimens.doneCurrencySize,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
