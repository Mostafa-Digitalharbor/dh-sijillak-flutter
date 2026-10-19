import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import '../../../pipeline/data/datasources/pipeline_mock_store.dart';
import 'quote_endpoints.dart';
import 'quote_mock_store.dart';

/// Fake quotes backend: fixtures in `assets/mock/quote/` plus in-memory
/// state, so an approval shows up in later reads.
class QuoteMockApi implements MockApiModule {
  QuoteMockApi(this._assets, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      _store = QuoteMockStore.of(_assets);

  static const String _statusApproved = 'approved';
  static const String _statusSent = 'sent';

  /// How long a freshly created quote stays valid.
  static const int _validityDays = 30;

  final MockAssets _assets;
  final DateTime Function() _clock;
  final QuoteMockStore _store;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, QuoteEndpoints.quotePattern, _get),
    MockRoute(HttpMethod.post, QuoteEndpoints.approvePattern, _approve),
    MockRoute(
      HttpMethod.post,
      QuoteEndpoints.dealQuotesPattern,
      _createForDeal,
    ),
  ];

  Future<Object?> _get(MockRequest request) async =>
      _view(await _find(request));

  Future<Object?> _approve(MockRequest request) async {
    final quote = await _find(request);
    quote['status'] = _statusApproved;
    final dealId = quote['dealId'] as String?;
    if (dealId != null) {
      await PipelineMockStore.of(_assets, clock: _clock).markWon(dealId);
    }
    return _view(quote);
  }

  /// Builds the quote of a deal from the deal's current state: one line
  /// named after the deal and priced at its expected value. Asking again for
  /// the same deal returns the quote made the first time.
  Future<Object?> _createForDeal(MockRequest request) async {
    final dealId = request.pathParams[QuoteEndpoints.dealIdParam];
    final quotes = await _store.quotes;
    final existing = quotes.where((q) => q['dealId'] == dealId).firstOrNull;
    if (existing != null) return _view(existing);

    final deals = (await PipelineMockStore.of(
      _assets,
      clock: _clock,
    ).data).deals;
    final deal = deals.where((d) => d['id'] == dealId).firstOrNull;
    if (deal == null) throw NotFoundException('deal $dealId');

    final now = _clock();
    final number = quotes.fold<int>(
      0,
      (max, quote) =>
          (quote['number'] as int) > max ? quote['number'] as int : max,
    );
    final quote = <String, dynamic>{
      'number': number + 1,
      'customer': deal['customerName'],
      'dealTitle': deal['title'],
      'dealId': dealId,
      'status': _statusSent,
      'viewedAt': now.toIso8601String(),
      'validUntil': DateTime(
        now.year,
        now.month,
        now.day + _validityDays,
      ).toIso8601String(),
      'lines': [
        {'name': deal['title'], 'unitPrice': deal['value'], 'quantity': 1},
      ],
    };
    quotes.add(quote);
    return _view(quote);
  }

  Future<Json> _find(MockRequest request) async {
    final number = int.tryParse(
      request.pathParams[QuoteEndpoints.numberParam] ?? '',
    );
    return (await _store.quotes).firstWhere(
      (quote) => quote['number'] == number,
      orElse: () => throw NotFoundException('quote $number'),
    );
  }

  /// The quote as the API returns it: the customer's last view happened
  /// today at the fixture's time of day, as the demo story needs.
  Json _view(Json quote) {
    final viewed = DateTime.parse(quote['viewedAt']! as String);
    final now = _clock();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
      viewed.hour,
      viewed.minute,
    );
    return {...quote, 'viewedAt': today.toIso8601String()};
  }
}
