import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/invoices_dimens.dart';
import 'quantity_step_button.dart';

/// "+  3  -" control that changes the quantity of an invoice line.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.tint,
        borderRadius: BorderRadius.circular(AppRadius.r14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityStepButton(
            glyph: l10n.glyphPlus,
            label: l10n.increaseQty,
            onTap: onIncrease,
          ),
          const SizedBox(width: AppSpacing.s4),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: InvoicesDimens.quantityMinWidth,
            ),
            child: Text(
              context.digits('$quantity'),
              textAlign: TextAlign.center,
              style: AppTextStyles.title.restyle(
                fontSize: InvoicesDimens.quantitySize,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          QuantityStepButton(
            glyph: l10n.glyphMinus,
            label: l10n.decreaseQty,
            onTap: onDecrease,
          ),
        ],
      ),
    );
  }
}
