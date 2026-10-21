import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import '../../../customer/data/datasources/customer_mock_store.dart';
import '../../../invoices/data/datasources/invoices_mock_store.dart';
import '../../../pipeline/data/datasources/pipeline_mock_store.dart';
import '../../../quote/data/datasources/quote_mock_store.dart';
import 'search_endpoints.dart';
import 'search_text.dart';

/// Fake search backend. It reads the same in-memory tables as the customers,
/// pipeline, invoices and quotes APIs, so anything created elsewhere in the
/// app is found immediately.
class SearchMockApi implements MockApiModule {
  SearchMockApi(this._assets);

  /// The most hits the server returns for one group.
  static const int groupLimit = 5;

  final MockAssets _assets;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, SearchEndpoints.search, _search),
  ];

  Future<Object?> _search(MockRequest request) async {
    final query = SearchText.normalize(
      request.query[SearchEndpoints.queryParam] ?? '',
    );
    if (query.isEmpty) {
      return {
        SearchEndpoints.customersKey: <Json>[],
        SearchEndpoints.dealsKey: <Json>[],
        SearchEndpoints.invoicesKey: <Json>[],
        SearchEndpoints.quotesKey: <Json>[],
      };
    }
    return {
      SearchEndpoints.customersKey: await _customers(query),
      SearchEndpoints.dealsKey: await _deals(query),
      SearchEndpoints.invoicesKey: await _invoices(query),
      SearchEndpoints.quotesKey: await _quotes(query),
    };
  }

  Future<List<Json>> _customers(String query) async {
    final customers = await CustomerMockStore.of(_assets).customers;
    return _top(
      customers,
      (c) => SearchText.matchesAny(query, [c['name']]),
      const ['id', 'name', 'location', 'openDeals'],
    );
  }

  Future<List<Json>> _deals(String query) async {
    final deals = (await PipelineMockStore.of(_assets).data).deals;
    return _top(
      deals,
      (d) => SearchText.matchesAny(query, [d['title'], d['customerName']]),
      const ['id', 'title', 'stage', 'value', 'customerId', 'customerName'],
    );
  }

  Future<List<Json>> _invoices(String query) async {
    final store = InvoicesMockStore.of(_assets);
    await store.ensureLoaded();
    return _top(
      store.invoices,
      (i) => SearchText.matchesAny(query, [i['number'], i['customer']]),
      const ['number', 'customer', 'amount', 'status'],
    );
  }

  Future<List<Json>> _quotes(String query) async {
    final quotes = await QuoteMockStore.of(_assets).quotes;
    return _top(
      quotes,
      (q) => SearchText.matchesAny(query, [
        q['number'],
        q['customer'],
        q['dealTitle'],
      ]),
      const ['number', 'customer', 'dealTitle', 'status'],
    );
  }

  /// The first [groupLimit] rows passing [matches], reduced to [fields].
  static List<Json> _top(
    List<Json> rows,
    bool Function(Json row) matches,
    List<String> fields,
  ) => [
    for (final row in rows.where(matches).take(groupLimit))
      {for (final field in fields) field: row[field]},
  ];
}
