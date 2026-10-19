import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/document_line.dart';
import 'quantity_stepper.dart';

/// A product / service line of the invoice being drafted, with its stepper.
class NewInvoiceLineCard extends StatelessWidget {
  const NewInvoiceLineCard({
    super.key,
    required this.line,
    required this.onQuantityChanged,
  });

  final DocumentLine line;

  /// Called with +1 / -1 when the stepper is used.
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.s14),
      radius: AppRadius.r18,
      fill: AppColors.white78,
      shadow: false,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name,
                  style: AppTextStyles.bodyBold.restyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  context.l10n.unitPriceLine(
                    context.amount(line.unitPrice),
                    context.amount(line.total),
                  ),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          QuantityStepper(
            quantity: line.quantity,
            onIncrease: () => onQuantityChanged(1),
            onDecrease: () => onQuantityChanged(-1),
          ),
        ],
      ),
    );
  }
}
