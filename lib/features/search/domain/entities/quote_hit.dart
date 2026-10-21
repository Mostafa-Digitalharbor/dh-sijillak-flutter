import 'package:equatable/equatable.dart';

import '../../../quote/domain/entities/quote_document.dart';

/// A quote matched by the global search.
class QuoteHit extends Equatable {
  const QuoteHit({
    required this.number,
    required this.customer,
    required this.dealTitle,
    required this.status,
  });

  final int number;
  final String customer;
  final String dealTitle;
  final QuoteStatus status;

  @override
  List<Object?> get props => [number, customer, dealTitle, status];
}
