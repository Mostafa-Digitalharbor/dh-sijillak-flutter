import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/document_card.dart';
import '../../../../shared/widgets/label_value.dart';
import '../../../../shared/widgets/line_item_row.dart';
import '../../../../shared/widgets/party_header.dart';
import '../../../../shared/widgets/summary_row.dart';
import '../../../../shared/widgets/total_bar.dart';
import '../../domain/entities/invoice_detail.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_dates.dart';
import 'invoice_qr.dart';

/// The tax invoice: billed party with QR, dates, lines, VAT and amount due.
class InvoiceDocumentCard extends StatelessWidget {
  const InvoiceDocumentCard({super.key, required this.invoice});

  final InvoiceDetail invoice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totals = invoice.totals;
    return DocumentCard(
      padding: const EdgeInsets.all(AppSpacing.s18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PartyHeader(
            showBadge: false,
            eyebrow: l10n.taxInvoiceTo,
            name: invoice.customer,
            subtitle: l10n.vatNumberLine(context.digits(invoice.vatNumber)),
            nameSize: InvoicesDimens.partyNameSize,
            lineGap: AppSpacing.s3,
            trailing: const InvoiceQr(),
          ),
          const SizedBox(height: AppSpacing.s14),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: AppColors.docTint,
              borderRadius: BorderRadius.circular(AppRadius.r14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LabelValue(
                    label: l10n.issueDate,
                    value: context.dayMonthYear(invoice.issueDate),
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: LabelValue(
                    label: l10n.dueDate,
                    value: context.dayMonthYear(invoice.dueDate),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s14),
          for (final line in invoice.lines)
            LineItemRow(
              name: line.name,
              detail: l10n.lineQtyPrice(
                context.digits('${line.quantity}'),
                context.amount(line.unitPrice),
              ),
              amount: context.amount(line.total),
            ),
          const SizedBox(height: AppSpacing.s14),
          SummaryRow(
            label: l10n.subtotalBeforeVat,
            value: l10n.amountSar(context.amount(totals.subtotal)),
          ),
          const SizedBox(height: AppSpacing.s8),
          SummaryRow(
            label: l10n.vat15,
            value: l10n.amountSar(context.amount(totals.vat)),
          ),
          const SizedBox(height: AppSpacing.s12),
          TotalBar(
            label: l10n.totalDue,
            value: l10n.amountSar(context.amount(totals.total)),
          ),
        ],
      ),
    );
  }
}
