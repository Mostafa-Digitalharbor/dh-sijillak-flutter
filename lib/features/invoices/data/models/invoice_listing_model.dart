import '../../../../core/network/api_client.dart';
import '../../domain/entities/invoice_listing.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/invoices_overview.dart';
import 'invoice_status_code.dart';

/// JSON mapping of the invoices list response.
abstract final class InvoiceListingModel {
  static InvoiceListing fromJson(Json json) => InvoiceListing(
    overview: _overview(json['overview'] as Json),
    invoices: [
      for (final row in (json['invoices'] as List).cast<Json>()) _summary(row),
    ],
  );

  static InvoicesOverview _overview(Json json) => InvoicesOverview(
    paid: (json['paid'] as num).toInt(),
    due: (json['due'] as num).toInt(),
    late: (json['late'] as num).toInt(),
  );

  static InvoiceSummary _summary(Json json) => InvoiceSummary(
    customer: json['customer'] as String,
    number: (json['number'] as num).toInt(),
    date: DateTime.parse(json['date'] as String),
    amount: (json['amount'] as num).toInt(),
    status: InvoiceStatusCode.fromCode(json['status'] as String),
  );
}
