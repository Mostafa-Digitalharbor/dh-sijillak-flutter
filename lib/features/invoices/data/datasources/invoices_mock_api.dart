import '../../../../core/constants/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import '../../../quote/data/datasources/quote_mock_store.dart';
import '../../domain/entities/invoice_period.dart';
import '../models/invoice_period_code.dart';
import 'invoices_endpoints.dart';
import 'invoices_mock_store.dart';

/// Fake invoices backend: fixtures in `assets/mock/invoices/` plus in-memory
/// state, so issued invoices and recorded payments show up in later reads.
class InvoicesMockApi implements MockApiModule {
  InvoicesMockApi(this._assets, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      _store = InvoicesMockStore.of(_assets, clock: clock);

  static const String _draftAsset = 'assets/mock/invoices/invoice_draft.json';
  static const String _productsAsset = 'assets/mock/invoices/products.json';
  static const String _statusPaid = 'paid';
  static const String _statusDue = 'due';
  static const String _amountField = 'amount';
  static const String _invoiceField = 'invoice';
  static const String _linesField = 'lines';
  static const String _invalidCode = 'invalid';
  static const String _exceedsCode = 'exceeds_balance';
  static const String _alreadyPaidCode = 'already_paid';

  final MockAssets _assets;
  final DateTime Function() _clock;
  final InvoicesMockStore _store;

  List<Json> get _invoices => _store.invoices;
  Map<String, Json> get _overviews => _store.overviews;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, InvoicesEndpoints.invoices, _list),
    MockRoute(HttpMethod.get, InvoicesEndpoints.draft, _draft),
    MockRoute(
      HttpMethod.get,
      InvoicesEndpoints.products,
      (_) => _assets.json(_productsAsset),
    ),
    MockRoute(HttpMethod.get, InvoicesEndpoints.invoicePattern, _detail),
    MockRoute(HttpMethod.post, InvoicesEndpoints.invoices, _issue),
    MockRoute(HttpMethod.post, InvoicesEndpoints.paymentsPattern, _pay),
  ];

  bool _inPeriod(InvoicePeriod period, DateTime date) {
    final today = _clock();
    final last = DateTime(today.year, today.month - 1);
    return switch (period) {
      InvoicePeriod.allTime => true,
      InvoicePeriod.thisYear => date.year == today.year,
      InvoicePeriod.thisMonth =>
        date.year == today.year && date.month == today.month,
      InvoicePeriod.lastMonth =>
        date.year == last.year && date.month == last.month,
    };
  }

  /// Moves [delta] in the [status] column of every period overview that
  /// covers an invoice issued on [issued].
  void _shiftOverviews(DateTime issued, String status, int delta) {
    for (final period in InvoicePeriod.values) {
      if (!_inPeriod(period, issued)) continue;
      final overview = _overviews[period.code]!;
      overview[status] = (overview[status]! as int) + delta;
    }
  }

  Future<Object?> _list(MockRequest request) async {
    await _store.ensureLoaded();
    final status = request.query[InvoicesEndpoints.statusParam];
    final query = (request.query[InvoicesEndpoints.queryParam] ?? '')
        .trim()
        .toLowerCase();
    final period = InvoicePeriodCode.fromCode(
      request.query[InvoicesEndpoints.periodParam],
    );
    bool matches(Json invoice) =>
        (status == null || invoice['status'] == status) &&
        _inPeriod(period, DateTime.parse(invoice['issueDate']! as String)) &&
        (query.isEmpty ||
            (invoice['customer']! as String).toLowerCase().contains(query) ||
            '${invoice['number']}'.contains(query));
    return {
      'overview': {..._overviews[period.code]!},
      'invoices': [
        for (final invoice in _invoices)
          if (matches(invoice))
            {
              'customer': invoice['customer'],
              'number': invoice['number'],
              'date': invoice['issueDate'],
              _amountField: invoice[_amountField],
              'status': invoice['status'],
            },
      ],
    };
  }

  Future<Object?> _detail(MockRequest request) async {
    await _store.ensureLoaded();
    return _view(_find(request));
  }

  Future<Object?> _draft(MockRequest request) async {
    final draft = (await _assets.json(_draftAsset)).asJson;
    final quoteNumber = int.tryParse(
      request.query[InvoicesEndpoints.quoteParam] ?? '',
    );
    final quote = quoteNumber == null ? null : await _quote(quoteNumber);
    return {
      ...draft,
      if (quote != null) ...{
        'customer': quote['customer'],
        _linesField: quote[_linesField],
      },
      'issueDate': InvoicesMockStore.dateOnly(_clock()).toIso8601String(),
    };
  }

  Future<Json> _quote(int number) async {
    final quotes = await QuoteMockStore.of(_assets).quotes;
    return quotes.firstWhere(
      (quote) => quote['number'] == number,
      orElse: () => throw NotFoundException('quote $number'),
    );
  }

  Future<Object?> _issue(MockRequest request) async {
    await _store.ensureLoaded();
    final body = request.body;
    final lines = [
      for (final line
          in ((body[_linesField] as List?) ?? const []).cast<Json>())
        if (((line['quantity'] as num?) ?? 0) > 0) line,
    ];
    if (lines.isEmpty || (body['customer'] as String? ?? '').isEmpty) {
      throw const ValidationException(fields: {_linesField: _invalidCode});
    }
    final issueDate = DateTime.parse(body['issueDate']! as String);
    final terms = (body['paymentTermsDays']! as num).toInt();
    final subtotal = lines.fold<num>(
      0,
      (sum, line) =>
          sum + (line['unitPrice']! as num) * (line['quantity']! as num),
    );
    final amount = (subtotal * (1 + AppConfig.vatRate)).round();
    final number =
        _invoices.fold<int>(
          0,
          (max, invoice) => (invoice['number']! as int) > max
              ? invoice['number']! as int
              : max,
        ) +
        1;
    final invoice = <String, dynamic>{
      'number': number,
      'customer': body['customer'],
      'vatNumber': body['vatNumber'],
      'issueDate': issueDate.toIso8601String(),
      'dueDate': DateTime(
        issueDate.year,
        issueDate.month,
        issueDate.day + terms,
      ).toIso8601String(),
      'status': _statusDue,
      _amountField: amount,
      _linesField: lines,
      'payments': <Json>[],
    };
    _invoices.insert(0, invoice);
    _shiftOverviews(issueDate, _statusDue, amount);
    return _view(invoice);
  }

  Future<Object?> _pay(MockRequest request) async {
    await _store.ensureLoaded();
    final invoice = _find(request);
    final payments = (invoice['payments']! as List).cast<Json>();
    final amount = ((request.body[_amountField] as num?) ?? 0).toInt();
    final owed = (invoice[_amountField]! as int) - _paidSum(payments);
    if (invoice['status'] == _statusPaid) {
      throw const ValidationException(
        fields: {_invoiceField: _alreadyPaidCode},
      );
    }
    if (amount <= 0) {
      throw const ValidationException(fields: {_amountField: _invalidCode});
    }
    if (amount > owed) {
      throw const ValidationException(fields: {_amountField: _exceedsCode});
    }
    payments.add({
      _amountField: amount,
      'method': request.body['method'],
      'date': request.body['date'],
      'reference': request.body['reference'],
      'hasReceipt': request.body['hasReceipt'] ?? false,
    });
    if (amount == owed) {
      final previous = invoice['status']! as String;
      final total = invoice[_amountField]! as int;
      final issued = DateTime.parse(invoice['issueDate']! as String);
      _shiftOverviews(issued, previous, -total);
      _shiftOverviews(issued, _statusPaid, total);
      invoice['status'] = _statusPaid;
    }
    return _view(invoice);
  }

  Json _find(MockRequest request) {
    final number = int.tryParse(
      request.pathParams[InvoicesEndpoints.numberParam] ?? '',
    );
    return _invoices.firstWhere(
      (invoice) => invoice['number'] == number,
      orElse: () => throw NotFoundException('invoice $number'),
    );
  }

  /// The invoice as the detail endpoint returns it (no list-only fields).
  Json _view(Json invoice) => {...invoice}..remove(_amountField);

  int _paidSum(List<Json> payments) => payments.fold(
    0,
    (sum, payment) => sum + (payment[_amountField]! as num).toInt(),
  );
}
