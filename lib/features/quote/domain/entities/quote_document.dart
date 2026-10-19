import 'package:equatable/equatable.dart';

import '../../../invoices/domain/entities/document_line.dart';
import '../../../invoices/domain/entities/document_totals.dart';

/// Where a quote stands with the customer.
enum QuoteStatus { sent, approved }

/// A priced quote sent to a customer for one of their deals.
class QuoteDocument extends Equatable {
  const QuoteDocument({
    required this.number,
    required this.customer,
    required this.dealTitle,
    required this.lines,
    this.dealId,
    this.status = QuoteStatus.sent,
    this.viewedAt,
    this.validUntil,
  });

  final int number;
  final String customer;
  final String dealTitle;
  final List<DocumentLine> lines;

  /// The pipeline deal this quote was sent for; approving the quote wins it.
  final String? dealId;
  final QuoteStatus status;

  /// When the customer last opened the quote, if they did.
  final DateTime? viewedAt;
  final DateTime? validUntil;

  bool get isApproved => status == QuoteStatus.approved;

  DocumentTotals get totals => DocumentTotals.of(lines);

  @override
  List<Object?> get props => [
    number,
    customer,
    dealTitle,
    lines,
    dealId,
    status,
    viewedAt,
    validUntil,
  ];
}
