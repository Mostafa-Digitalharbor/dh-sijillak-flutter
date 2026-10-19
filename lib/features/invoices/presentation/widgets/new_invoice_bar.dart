import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/currency_amount.dart';
import '../../../../shared/widgets/grow_row.dart';
import '../../../../shared/widgets/outline_action_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/document_totals.dart';
import '../constants/invoices_dimens.dart';

/// Grand total, issue / save-draft buttons and the auto-send note.
class NewInvoiceBar extends StatelessWidget {
  const NewInvoiceBar({
    super.key,
    required this.totals,
    required this.onIssue,
    this.submitting = false,
  });

  final DocumentTotals totals;

  /// Called when "issue invoice" is pressed.
  final VoidCallback onIssue;

  /// Whether the invoice is being issued (disables the button).
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                l10n.total,
                style: AppTextStyles.bodyBold.restyle(
                  color: AppColors.textStrong,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            CurrencyAmount(
              amount: totals.total,
              amountStyle: AppTextStyles.title.restyle(
                fontSize: InvoicesDimens.summaryAmountSize,
                color: AppColors.primary,
              ),
              currencyStyle: AppTextStyles.caption.restyle(
                fontSize: InvoicesDimens.currencySize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s10),
        GrowRow(
          items: [
            GrowItem(
              label: l10n.issueInvoice,
              fontSize: InvoicesDimens.actionFontSize,
              grow: InvoicesDimens.issueGrow,
              child: PrimaryButton(
                label: l10n.issueInvoice,
                height: InvoicesDimens.actionHeight,
                radius: InvoicesDimens.actionRadius,
                fontSize: InvoicesDimens.actionFontSize,
                enabled: !submitting,
                onPressed: onIssue,
              ),
            ),
            GrowItem(
              label: l10n.draft,
              fontSize: InvoicesDimens.draftLabelSize,
              extraWidth: InvoicesDimens.draftExtraWidth,
              child: OutlineActionButton(
                label: l10n.draft,
                fontSize: InvoicesDimens.draftLabelSize,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s10),
        Text(
          l10n.invoiceAutoSendNote,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.restyle(color: AppColors.textSubtle),
        ),
      ],
    );
  }
}
