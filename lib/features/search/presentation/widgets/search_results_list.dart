import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../domain/entities/search_results.dart';
import '../constants/search_dimens.dart';
import 'customer_hit_row.dart';
import 'deal_hit_row.dart';
import 'invoice_hit_row.dart';
import 'quote_hit_row.dart';
import 'search_section.dart';

/// The grouped hits of a query: customers, deals, invoices and quotes. Groups
/// without hits are left out.
class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        bottom: context.bottomPad(SearchDimens.bottomPadding),
      ),
      children: [
        if (results.customers.isNotEmpty)
          SearchSection(
            title: l10n.navCustomers,
            rows: [
              for (final hit in results.customers) CustomerHitRow(hit: hit),
            ],
          ),
        if (results.deals.isNotEmpty)
          SearchSection(
            title: l10n.navPipeline,
            rows: [for (final hit in results.deals) DealHitRow(hit: hit)],
          ),
        if (results.invoices.isNotEmpty)
          SearchSection(
            title: l10n.invoices,
            rows: [for (final hit in results.invoices) InvoiceHitRow(hit: hit)],
          ),
        if (results.quotes.isNotEmpty)
          SearchSection(
            title: l10n.searchGroupQuotes,
            rows: [for (final hit in results.quotes) QuoteHitRow(hit: hit)],
          ),
      ],
    );
  }
}
