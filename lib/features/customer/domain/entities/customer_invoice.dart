import 'package:equatable/equatable.dart';

import '../../../invoices/domain/entities/invoice_summary.dart';

/// An invoice as listed on a customer's profile.
class CustomerInvoice extends Equatable {
  const CustomerInvoice({
    required this.number,
    required this.date,
    required this.amount,
    required this.status,
  });

  final int number;
  final DateTime date;
  final int amount;
  final InvoiceStatus status;

  @override
  List<Object?> get props => [number, date, amount, status];
}
