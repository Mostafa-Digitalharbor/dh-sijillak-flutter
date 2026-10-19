import 'package:equatable/equatable.dart';

import 'document_line.dart';
import 'document_totals.dart';

/// An invoice being prepared, before it is issued.
class InvoiceDraft extends Equatable {
  const InvoiceDraft({
    required this.customer,
    required this.vatNumber,
    required this.issueDate,
    required this.paymentTermsDays,
    required this.lines,
  });

  final String customer;
  final String vatNumber;
  final DateTime issueDate;

  /// Days after [issueDate] by which the invoice must be paid.
  final int paymentTermsDays;
  final List<DocumentLine> lines;

  DocumentTotals get totals => DocumentTotals.of(lines);

  InvoiceDraft withLines(List<DocumentLine> lines) => InvoiceDraft(
    customer: customer,
    vatNumber: vatNumber,
    issueDate: issueDate,
    paymentTermsDays: paymentTermsDays,
    lines: lines,
  );

  @override
  List<Object?> get props => [
    customer,
    vatNumber,
    issueDate,
    paymentTermsDays,
    lines,
  ];
}
