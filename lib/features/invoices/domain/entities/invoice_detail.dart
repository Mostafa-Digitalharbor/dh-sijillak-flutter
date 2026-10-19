import 'package:equatable/equatable.dart';

import 'document_line.dart';
import 'document_totals.dart';
import 'invoice_summary.dart';
import 'payment.dart';

/// A tax invoice as shown on the detail and payment screens.
class InvoiceDetail extends Equatable {
  const InvoiceDetail({
    required this.number,
    required this.customer,
    required this.vatNumber,
    required this.issueDate,
    required this.dueDate,
    required this.lines,
    this.status = InvoiceStatus.due,
    this.payments = const [],
  });

  final int number;
  final String customer;
  final String vatNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final List<DocumentLine> lines;
  final InvoiceStatus status;
  final List<Payment> payments;

  DocumentTotals get totals => DocumentTotals.of(lines);

  bool get isPaid => status == InvoiceStatus.paid;

  int get paidAmount => payments.fold(0, (sum, p) => sum + p.amount);

  /// Amount still owed, never negative.
  int get balance {
    final remaining = totals.total.round() - paidAmount;
    return remaining < 0 ? 0 : remaining;
  }

  /// The most recently recorded payment, if any.
  Payment? get latestPayment => payments.isEmpty ? null : payments.last;

  /// Whole days from [now] until the due date (0 once it has passed).
  int daysUntilDue(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final days = due.difference(today).inDays;
    return days < 0 ? 0 : days;
  }

  @override
  List<Object?> get props => [
    number,
    customer,
    vatNumber,
    issueDate,
    dueDate,
    lines,
    status,
    payments,
  ];
}
