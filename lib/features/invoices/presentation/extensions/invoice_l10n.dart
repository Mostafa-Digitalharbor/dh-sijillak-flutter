import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/invoice_period.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/payment_method.dart';

extension InvoiceStatusL10n on InvoiceStatus {
  String localized(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      InvoiceStatus.paid => l10n.statusPaid,
      InvoiceStatus.due => l10n.statusDue,
      InvoiceStatus.late => l10n.statusLate,
    };
  }
}

extension InvoicePeriodL10n on InvoicePeriod {
  String localized(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      InvoicePeriod.thisMonth => l10n.thisMonth,
      InvoicePeriod.lastMonth => l10n.periodLastMonth,
      InvoicePeriod.thisYear => l10n.periodThisYear,
      InvoicePeriod.allTime => l10n.periodAllTime,
    };
  }
}

extension PaymentMethodL10n on PaymentMethod {
  String localized(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      PaymentMethod.bankTransfer => l10n.payBankTransfer,
      PaymentMethod.card => l10n.payCard,
      PaymentMethod.cash => l10n.payCash,
    };
  }

  /// Label of the reference-number field for this method.
  String referenceLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      PaymentMethod.bankTransfer => l10n.refTransferNo,
      PaymentMethod.card => l10n.refTransactionNo,
      PaymentMethod.cash => l10n.refVoucherNo,
    };
  }
}
