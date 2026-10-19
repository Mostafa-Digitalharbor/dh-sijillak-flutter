import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/currency_amount.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/invoice_summary.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_dates.dart';
import '../extensions/invoice_l10n.dart';
import '../extensions/invoice_status_style.dart';

/// One invoice of the list: customer, number and date, amount and status.
class InvoiceRow extends StatelessWidget {
  const InvoiceRow({super.key, required this.invoice});

  final InvoiceSummary invoice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.invoice, extra: invoice.number),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.s14),
        radius: AppRadius.r18,
        fill: AppColors.white74,
        shadow: false,
        child: Row(
          children: [
            const IconTile(
              icon: AppIcons.doc,
              size: InvoicesDimens.rowIconTile,
              iconSize: InvoicesDimens.rowIconSize,
              radius: AppRadius.r14,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.customer,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold.restyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    context.l10n.invoiceRowSubtitle(
                      context.digits('${invoice.number}'),
                      context.dayMonth(invoice.date),
                    ),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CurrencyAmount(
                  amount: invoice.amount,
                  amountStyle: AppTextStyles.bodyBold.restyle(
                    fontWeight: FontWeight.w800,
                  ),
                  currencyStyle: AppTextStyles.caption.restyle(
                    fontSize: InvoicesDimens.rowCurrencySize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                StatusPill(
                  text: invoice.status.localized(context),
                  background: invoice.status.background,
                  foreground: invoice.status.foreground,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
