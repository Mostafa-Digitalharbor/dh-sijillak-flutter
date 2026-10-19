import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/grow_row.dart';
import '../../../../shared/widgets/outline_action_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/invoice_detail.dart';
import '../constants/invoices_dimens.dart';
import 'payment_sheet.dart';

/// Record-payment and share buttons pinned under the invoice.
class InvoiceDetailActions extends StatelessWidget {
  const InvoiceDetailActions({
    super.key,
    required this.invoice,
    required this.onPaymentRecorded,
  });

  final InvoiceDetail invoice;

  /// Called once the payment sheet closes, so the invoice can be refreshed.
  final VoidCallback onPaymentRecorded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GrowRow(
      items: [
        GrowItem(
          label: l10n.recordPayment,
          fontSize: InvoicesDimens.actionFontSize,
          extraWidth: InvoicesDimens.primaryIconExtra,
          child: PrimaryButton(
            label: l10n.recordPayment,
            icon: AppIcons.card,
            height: InvoicesDimens.actionHeight,
            radius: InvoicesDimens.actionRadius,
            fontSize: InvoicesDimens.actionFontSize,
            enabled: !invoice.isPaid,
            onPressed: () => showPaymentSheet(
              context,
              invoice,
            ).then((_) => onPaymentRecorded()),
          ),
        ),
        GrowItem(
          label: l10n.share,
          fontSize: InvoicesDimens.actionFontSize,
          extraWidth: InvoicesDimens.outlineIconExtra,
          child: OutlineActionButton(
            label: l10n.share,
            icon: AppIcons.share,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
