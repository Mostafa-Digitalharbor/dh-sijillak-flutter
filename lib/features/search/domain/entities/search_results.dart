import 'package:equatable/equatable.dart';

import 'customer_hit.dart';
import 'deal_hit.dart';
import 'invoice_hit.dart';
import 'quote_hit.dart';

/// Everything a query matched, grouped by kind.
class SearchResults extends Equatable {
  const SearchResults({
    this.customers = const [],
    this.deals = const [],
    this.invoices = const [],
    this.quotes = const [],
  });

  /// The result of a query that matched nothing.
  static const empty = SearchResults();

  final List<CustomerHit> customers;
  final List<DealHit> deals;
  final List<InvoiceHit> invoices;
  final List<QuoteHit> quotes;

  int get total =>
      customers.length + deals.length + invoices.length + quotes.length;

  bool get isEmpty => total == 0;

  @override
  List<Object?> get props => [customers, deals, invoices, quotes];
}
