import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/document_card.dart';
import '../../../../shared/widgets/line_item_row.dart';
import '../../../../shared/widgets/party_header.dart';
import '../../../../shared/widgets/summary_row.dart';
import '../../../../shared/widgets/total_bar.dart';
import '../../domain/entities/quote_document.dart';
import '../constants/quote_dimens.dart';

/// The quote itself: customer, priced lines, VAT and grand total.
class QuoteDocumentCard extends StatelessWidget {
  const QuoteDocumentCard({super.key, required this.quote});

  final QuoteDocument quote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totals = quote.totals;
    return DocumentCard(
      child: Column(
        children: [
          PartyHeader(
            name: quote.customer,
            subtitle: l10n.opportunityLine(quote.dealTitle),
            badgeSize: QuoteDimens.badgeSize,
            badgeFontSize: QuoteDimens.badgeFontSize,
          ),
          const SizedBox(height: AppSpacing.s12),
          for (final line in quote.lines)
            LineItemRow(
              name: line.name,
              detail: l10n.lineQtyPrice(
                context.digits('${line.quantity}'),
                context.amount(line.unitPrice),
              ),
              amount: context.amount(line.total),
            ),
          const SizedBox(height: AppSpacing.s12),
          SummaryRow(
            label: l10n.vat15,
            value: l10n.amountSar(context.amount(totals.vat)),
          ),
          const SizedBox(height: AppSpacing.s12),
          TotalBar(
            label: l10n.total,
            value: l10n.amountSar(context.amount(totals.total)),
          ),
        ],
      ),
    );
  }
}
