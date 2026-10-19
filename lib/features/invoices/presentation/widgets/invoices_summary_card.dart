import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/currency_amount.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/invoices_overview.dart';
import '../constants/invoices_dimens.dart';
import 'invoice_legend_item.dart';

/// Total billed amount with a paid / due / overdue split bar and legend.
class InvoicesSummaryCard extends StatelessWidget {
  const InvoicesSummaryCard({super.key, required this.overview});

  final InvoicesOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      fill: AppColors.white74,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  l10n.totalInvoices,
                  style: AppTextStyles.subtitle.restyle(
                    fontSize: InvoicesDimens.summaryTitleSize,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              CurrencyAmount(
                amount: overview.total,
                amountStyle: AppTextStyles.title.restyle(
                  fontSize: InvoicesDimens.summaryAmountSize,
                ),
                currencyStyle: AppTextStyles.caption.restyle(
                  fontSize: InvoicesDimens.currencySize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: SizedBox(
                height: InvoicesDimens.summaryBarHeight,
                child: Row(
                  children: [
                    Expanded(
                      flex: overview.percent(overview.paid),
                      child: const ColoredBox(color: AppColors.accent),
                    ),
                    const SizedBox(width: InvoicesDimens.summaryBarGap),
                    Expanded(
                      flex: overview.percent(overview.due),
                      child: const ColoredBox(color: AppColors.amber),
                    ),
                    const SizedBox(width: InvoicesDimens.summaryBarGap),
                    Expanded(
                      flex: overview.percent(overview.late),
                      child: const ColoredBox(color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s6,
            children: [
              InvoiceLegendItem(
                color: AppColors.accent,
                text: l10n.legendPaid(context.amount(overview.paid)),
              ),
              InvoiceLegendItem(
                color: AppColors.amber,
                text: l10n.legendDue(context.amount(overview.due)),
              ),
              InvoiceLegendItem(
                color: AppColors.warning,
                text: l10n.legendLate(context.amount(overview.late)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
