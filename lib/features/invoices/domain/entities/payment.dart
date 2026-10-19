import 'package:equatable/equatable.dart';

import 'payment_method.dart';

/// A payment received against an invoice.
class Payment extends Equatable {
  const Payment({
    required this.amount,
    required this.method,
    required this.date,
    this.reference,
    this.hasReceipt = false,
  });

  final int amount;
  final PaymentMethod method;
  final DateTime date;

  /// Transfer, transaction or voucher number typed by the user, if any.
  final String? reference;

  /// Whether a receipt image was attached.
  final bool hasReceipt;

  @override
  List<Object?> get props => [amount, method, date, reference, hasReceipt];
}
