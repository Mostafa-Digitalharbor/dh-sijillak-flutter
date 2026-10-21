import '../../../../core/network/api_client.dart';
import '../../../invoices/data/models/invoice_status_code.dart';
import '../../../pipeline/domain/entities/deal_stage.dart';
import '../../../quote/data/models/quote_model.dart';
import '../../domain/entities/customer_hit.dart';
import '../../domain/entities/deal_hit.dart';
import '../../domain/entities/invoice_hit.dart';
import '../../domain/entities/quote_hit.dart';
import '../../domain/entities/search_results.dart';
import '../datasources/search_endpoints.dart';

/// JSON mapping of the GET /search response.
abstract final class SearchResultsModel {
  static SearchResults fromJson(Json json) => SearchResults(
    customers: [
      for (final row in _rows(json, SearchEndpoints.customersKey))
        CustomerHit(
          id: row['id'] as String,
          name: row['name'] as String,
          location: row['location'] as String,
          openDeals: (row['openDeals'] as num).toInt(),
        ),
    ],
    deals: [
      for (final row in _rows(json, SearchEndpoints.dealsKey))
        DealHit(
          id: row['id'] as String,
          title: row['title'] as String,
          stage: DealStage.values.byName(row['stage'] as String),
          value: (row['value'] as num).toInt(),
          customerId: row['customerId'] as String,
          customerName: row['customerName'] as String,
        ),
    ],
    invoices: [
      for (final row in _rows(json, SearchEndpoints.invoicesKey))
        InvoiceHit(
          number: (row['number'] as num).toInt(),
          customer: row['customer'] as String,
          amount: (row['amount'] as num).toInt(),
          status: InvoiceStatusCode.fromCode(row['status'] as String),
        ),
    ],
    quotes: [
      for (final row in _rows(json, SearchEndpoints.quotesKey))
        QuoteHit(
          number: (row['number'] as num).toInt(),
          customer: row['customer'] as String,
          dealTitle: row['dealTitle'] as String,
          status: QuoteStatusCode.fromCode(row['status'] as String),
        ),
    ],
  );

  static List<Json> _rows(Json json, String key) =>
      ((json[key] as List?) ?? const []).cast<Json>();
}
