import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/payment_method.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_l10n.dart';

/// Selectable tile for one [PaymentMethod] in the payment sheet.
class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.quick,
          constraints: const BoxConstraints(
            minHeight: InvoicesDimens.methodTileHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.tint : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? AppSizes.borderThick : AppSizes.borderThin,
            ),
          ),
          child: Text(
            method.localized(context),
            textAlign: TextAlign.center,
            style: AppFonts.tajawal(
              fontSize: InvoicesDimens.methodLabelSize,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textStrong,
            ),
          ),
        ),
      ),
    );
  }
}
