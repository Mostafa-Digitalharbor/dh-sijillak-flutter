import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';

/// In-memory quotes table of the mock backend, shared by every mock module
/// that reads quotes (quotes themselves, and invoices started from a quote).
/// One instance exists per [MockAssets], i.e. per composition root.
class QuoteMockStore {
  QuoteMockStore._(this._assets);

  static final Expando<QuoteMockStore> _stores = Expando();

  /// Fixture of the quotes.
  static const String asset = 'assets/mock/quote/quotes.json';

  static QuoteMockStore of(MockAssets assets) =>
      _stores[assets] ??= QuoteMockStore._(assets);

  final MockAssets _assets;
  Future<List<Json>>? _quotes;

  /// The loaded quotes (loads the fixtures on first access).
  Future<List<Json>> get quotes => _quotes ??= _load();

  Future<List<Json>> _load() async => [
    ...(await _assets.json(asset)).asJsonList,
  ];
}
