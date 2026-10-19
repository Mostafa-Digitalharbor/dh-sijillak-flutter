import 'package:equatable/equatable.dart';

import 'payment_method.dart';

/// The values entered in the record-payment sheet.
class NewPayment extends Equatable {
  const NewPayment({
    required this.amount,
    required this.method,
    required this.date,
    this.reference,
    this.hasReceipt = false,
  });

  final int amount;
  final PaymentMethod method;
  final DateTime date;
  final String? reference;
  final bool hasReceipt;

  @override
  List<Object?> get props => [amount, method, date, reference, hasReceipt];
}
