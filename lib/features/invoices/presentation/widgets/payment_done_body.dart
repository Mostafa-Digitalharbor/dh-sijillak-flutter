import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/payment.dart';
import 'payment_done_details.dart';
import 'payment_done_header.dart';
import 'payment_done_note.dart';

/// Amount received, payment details and the deal-won note.
class PaymentDoneBody extends StatelessWidget {
  const PaymentDoneBody({
    super.key,
    required this.invoice,
    required this.payment,
  });

  final InvoiceDetail invoice;
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentDoneHeader(amount: payment.amount),
        const SizedBox(height: AppSpacing.s18),
        PaymentDoneDetails(invoice: invoice, payment: payment),
        if (invoice.isPaid) ...[
          const SizedBox(height: AppSpacing.s18),
          const PaymentDoneNote(),
        ],
      ],
    );
  }
}
