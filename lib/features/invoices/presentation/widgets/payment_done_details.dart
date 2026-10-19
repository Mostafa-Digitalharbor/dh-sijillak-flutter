import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/key_value_row.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/payment.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_l10n.dart';

/// Customer, invoice, method and status of the [payment] just recorded.
class PaymentDoneDetails extends StatelessWidget {
  const PaymentDoneDetails({
    super.key,
    required this.invoice,
    required this.payment,
  });

  final InvoiceDetail invoice;
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s6,
      ),
      fill: AppColors.white78,
      shadow: false,
      child: Column(
        children: [
          KeyValueRow(
            label: l10n.customerLabel,
            value: invoice.customer,
            divider: true,
          ),
          KeyValueRow(
            label: l10n.invoiceLabel,
            value: l10n.invoiceNumberValue(context.digits('${invoice.number}')),
            divider: true,
          ),
          KeyValueRow(
            label: l10n.paymentMethod,
            value: payment.method.localized(context),
            divider: true,
          ),
          KeyValueRow(
            label: l10n.invoiceStatus,
            trailing: StatusPill(
              text: invoice.isPaid ? l10n.paidInFull : l10n.paidPartially,
              background: AppColors.paidBg,
              foreground: AppColors.primary,
              fontSize: InvoicesDimens.pillFontSize,
              padding: InvoicesDimens.donePillPadding,
            ),
          ),
        ],
      ),
    );
  }
}
