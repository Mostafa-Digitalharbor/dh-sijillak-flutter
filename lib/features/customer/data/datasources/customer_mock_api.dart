import '../../../../core/error/exceptions.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import '../../../invoices/data/datasources/invoices_mock_store.dart';
import '../../../pipeline/data/datasources/pipeline_mock_store.dart';
import 'customer_endpoints.dart';

/// Fake customers endpoints served by the mock backend. Activity times in the
/// fixture are "hours/days ago", resolved against the current time so the
/// timeline keeps reading the same ("2 hours ago", "yesterday"...).
///
/// The deals of a customer are read from the shared pipeline state (linked by
/// customer id) and its invoices from the shared invoices state (linked by
/// customer name), so deals and invoices created elsewhere show up here.
class CustomerMockApi implements MockApiModule {
  CustomerMockApi(this._assets, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  static const _customersAsset = 'assets/mock/customer/customers.json';
  static const _noonHour = 12;
  static const _summaryFields = [
    'id',
    'name',
    'location',
    'openDeals',
    'amountDue',
  ];
  static const _dealFields = ['id', 'title', 'stage', 'value', 'probability'];

  final MockAssets _assets;
  final DateTime Function() _clock;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, CustomerEndpoints.customers, _list),
    MockRoute(
      HttpMethod.get,
      CustomerEndpoints.customerPattern,
      (request) => _customer(request.pathParams['id']),
    ),
    MockRoute(
      HttpMethod.get,
      CustomerEndpoints.dealsPattern,
      (request) => _deals(request.pathParams['id']),
    ),
    MockRoute(
      HttpMethod.get,
      CustomerEndpoints.invoicesPattern,
      (request) => _invoices(request.pathParams['id']),
    ),
  ];

  Future<List<Map<String, dynamic>>> _all() async =>
      ((await _assets.json(_customersAsset))! as List)
          .cast<Map<String, dynamic>>();

  Future<Map<String, dynamic>> _find(String? id) async {
    final matches = (await _all()).where((customer) => customer['id'] == id);
    if (matches.isEmpty) throw NotFoundException('customer $id');
    return matches.first;
  }

  Future<Object?> _list(MockRequest request) async {
    final query = (request.query[CustomerEndpoints.queryParam] ?? '')
        .trim()
        .toLowerCase();
    bool matches(Map<String, dynamic> customer) =>
        query.isEmpty ||
        (customer['name'] as String).toLowerCase().contains(query) ||
        (customer['location'] as String).toLowerCase().contains(query);
    return [
      for (final customer in await _all())
        if (matches(customer))
          {for (final key in _summaryFields) key: customer[key]},
    ];
  }

  Future<Object?> _deals(String? id) async {
    await _find(id);
    final state = await PipelineMockStore.of(_assets).data;
    return [
      for (final deal in state.deals)
        if (deal['customerId'] == id)
          {for (final key in _dealFields) key: deal[key]},
    ];
  }

  Future<Object?> _invoices(String? id) async {
    final name = (await _find(id))['name'];
    final store = InvoicesMockStore.of(_assets);
    await store.ensureLoaded();
    return [
      for (final invoice in store.invoices)
        if (invoice['customer'] == name)
          {
            'number': invoice['number'],
            'date': invoice['issueDate'],
            'amount': invoice['amount'],
            'status': invoice['status'],
          },
    ];
  }

  Future<Object?> _customer(String? id) async {
    final customer = await _find(id);
    final now = _clock();
    return {
      ...customer,
      'activity': [
        for (final item in customer['activity'] as List)
          _resolveActivity(item as Map<String, dynamic>, now),
      ],
    };
  }

  static Map<String, dynamic> _resolveActivity(
    Map<String, dynamic> raw,
    DateTime now,
  ) {
    final startOfToday = DateTime(now.year, now.month, now.day);
    final DateTime at;
    if (raw['hoursAgo'] != null) {
      final earlier = now.subtract(Duration(hours: raw['hoursAgo'] as int));
      at = earlier.isBefore(startOfToday) ? startOfToday : earlier;
    } else {
      at = DateTime(
        now.year,
        now.month,
        now.day - (raw['daysAgo'] as int),
        _noonHour,
      );
    }
    return {
      for (final entry in raw.entries)
        if (entry.key != 'hoursAgo' && entry.key != 'daysAgo')
          entry.key: entry.value,
      'at': at.toIso8601String(),
    };
  }
}
