import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';

/// In-memory customers table of the mock backend, shared by every mock module
/// that knows customers (the customers API itself, deals and invoices).
/// One instance exists per [MockAssets], i.e. per composition root, so a
/// customer created through POST /customers is visible everywhere.
class CustomerMockStore {
  CustomerMockStore._(this._assets, this._clock);

  static final Expando<CustomerMockStore> _stores = Expando();

  static const _customersAsset = 'assets/mock/customer/customers.json';
  static const _defaultsAsset = 'assets/mock/pipeline/lead_defaults.json';

  /// Separator of the city and the sector in a customer's display location.
  static const _locationSeparator = ' · ';
  static const _firstCreatedId = 100;

  /// The store behind [assets]; created on first use with [clock].
  static CustomerMockStore of(
    MockAssets assets, {
    DateTime Function()? clock,
  }) => _stores[assets] ??= CustomerMockStore._(assets, clock ?? DateTime.now);

  final MockAssets _assets;
  final DateTime Function() _clock;
  Future<List<Json>>? _customers;
  int _nextId = _firstCreatedId;

  /// The customer table, newest created first (loads the fixtures on first
  /// access). Rows are in the full profile format.
  Future<List<Json>> get customers => _customers ??= _load();

  /// The customer [id], or null.
  Future<Json?> find(Object? id) async =>
      (await customers).where((customer) => customer['id'] == id).firstOrNull;

  /// The customer [id]; throws [NotFoundException] for an unknown one.
  Future<Json> require(Object? id) async =>
      await find(id) ?? (throw NotFoundException('customer $id'));

  /// Adds a customer from the submitted [body] and returns its profile.
  /// Throws [ValidationException] when the name is blank or the email is not
  /// an address.
  Future<Json> create(Json body) async {
    final name = _text(body['name']);
    final phone = _text(body['phone']);
    final email = _text(body['email']);
    final city = _text(body['city']);
    final sector = _text(body['sector']);
    final errors = <String, String>{
      if (name.isEmpty) 'name': 'required',
      if (email.isNotEmpty && !email.contains('@')) 'email': 'invalid',
    };
    if (errors.isNotEmpty) throw ValidationException(fields: errors);

    final today = _clock();
    final defaults =
        (await _assets.json(_defaultsAsset))! as Map<String, dynamic>;
    final customer = <String, dynamic>{
      'id': 'c-${_nextId++}',
      'name': name,
      'location': [
        city,
        sector,
      ].where((part) => part.isNotEmpty).join(_locationSeparator),
      'city': city,
      'sector': sector,
      'phone': phone,
      'email': email,
      'address': '',
      'commercialRegistration': '',
      'vatNumber': '',
      'customerSince': DateTime(
        today.year,
        today.month,
        today.day,
      ).toIso8601String(),
      'accountOwner': (defaults['owner'] as Map)['name'],
      'totalSales': 0,
      'amountDue': 0,
      'openDeals': 0,
      'activity': <Json>[],
    };
    (await customers).insert(0, customer);
    return customer;
  }

  static String _text(Object? value) => (value as String?)?.trim() ?? '';

  Future<List<Json>> _load() async => [
    ...((await _assets.json(_customersAsset))! as List).cast<Json>(),
  ];
}
