import 'package:equatable/equatable.dart';

enum InvoiceStatus { paid, due, late }

/// One row of the invoices list.
class InvoiceSummary extends Equatable {
  const InvoiceSummary({
    required this.customer,
    required this.number,
    required this.date,
    required this.amount,
    required this.status,
  });

  final String customer;
  final int number;
  final DateTime date;
  final int amount;
  final InvoiceStatus status;

  @override
  List<Object?> get props => [customer, number, date, amount, status];
}
