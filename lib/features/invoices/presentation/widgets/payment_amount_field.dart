import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/invoices_dimens.dart';

/// Large editable "amount received" field driven by [controller].
class PaymentAmountField extends StatelessWidget {
  const PaymentAmountField({super.key, required this.controller});

  /// Holds the typed amount; the owner pre-fills it with the amount due.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.amountReceived, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.s6),
        Container(
          constraints: const BoxConstraints(
            minHeight: InvoicesDimens.amountFieldHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(
              color: AppColors.accent,
              width: AppSizes.borderMedium,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: AppTextStyles.title.restyle(
                    fontSize: InvoicesDimens.amountFontSize,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Text(
                l10n.sar,
                style: AppTextStyles.bodyBold.restyle(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        Text(
          l10n.amountHelp,
          style: AppTextStyles.caption.restyle(color: AppColors.textSubtle),
        ),
      ],
    );
  }
}
