import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/summary_row.dart';
import '../../domain/entities/document_totals.dart';

/// Subtotal and VAT of the invoice being drafted.
class NewInvoiceTotalsCard extends StatelessWidget {
  const NewInvoiceTotalsCard({super.key, required this.totals});

  final DocumentTotals totals;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white78,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          SummaryRow(
            label: l10n.subtotalBeforeVat,
            value: l10n.amountSar(context.amount(totals.subtotal)),
          ),
          const SizedBox(height: AppSpacing.s8),
          SummaryRow(
            label: l10n.vat15,
            value: l10n.amountSar(context.amount(totals.vat)),
          ),
        ],
      ),
    );
  }
}
