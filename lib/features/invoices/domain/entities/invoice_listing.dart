import 'package:equatable/equatable.dart';

import 'invoice_summary.dart';
import 'invoices_overview.dart';

/// The invoices list screen's data: billing overview plus the matching rows.
class InvoiceListing extends Equatable {
  const InvoiceListing({required this.overview, required this.invoices});

  final InvoicesOverview overview;
  final List<InvoiceSummary> invoices;

  @override
  List<Object?> get props => [overview, invoices];
}
