import 'package:equatable/equatable.dart';

import '../../../invoices/domain/entities/invoice_summary.dart';

/// An invoice matched by the global search.
class InvoiceHit extends Equatable {
  const InvoiceHit({
    required this.number,
    required this.customer,
    required this.amount,
    required this.status,
  });

  final int number;
  final String customer;
  final int amount;
  final InvoiceStatus status;

  @override
  List<Object?> get props => [number, customer, amount, status];
}
