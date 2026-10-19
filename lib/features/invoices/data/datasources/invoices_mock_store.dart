import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';

/// In-memory invoices tables of the mock backend, shared by every mock module
/// that reads invoices (the invoices API itself and a customer's invoices).
/// One instance exists per [MockAssets], i.e. per composition root.
class InvoicesMockStore {
  InvoicesMockStore._(this._assets, this._clock);

  static final Expando<InvoicesMockStore> _stores = Expando();

  static const String _invoicesAsset = 'assets/mock/invoices/invoices.json';

  /// The store behind [assets]; created on first use with [clock].
  static InvoicesMockStore of(
    MockAssets assets, {
    DateTime Function()? clock,
  }) => _stores[assets] ??= InvoicesMockStore._(assets, clock ?? DateTime.now);

  /// [date] without its time of day.
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  final MockAssets _assets;
  final DateTime Function() _clock;
  Future<void>? _loading;

  /// Invoices, newest first. Valid after [ensureLoaded].
  final List<Json> invoices = [];

  /// Billing overview by period code. Valid after [ensureLoaded].
  final Map<String, Json> overviews = {};

  /// Loads the fixtures on first call.
  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    final data = (await _assets.json(_invoicesAsset)).asJson;
    final today = dateOnly(_clock());
    overviews
      ..clear()
      ..addAll({
        for (final entry in (data['overviews']! as Map).entries)
          entry.key as String: (entry.value as Map).cast<String, dynamic>(),
      });
    invoices
      ..clear()
      ..addAll([
        for (final raw in (data['invoices']! as List).cast<Json>())
          _resolve(raw, today),
      ]);
  }

  /// Turns the fixture's relative dates (months / days before today, payment
  /// delay, terms) into the absolute dates the API serves.
  Json _resolve(Json raw, DateTime today) {
    final issued = _issueDate(raw['issue']! as Map, today);
    return {
      for (final entry in raw.entries)
        if (entry.key != 'issue' && entry.key != 'termsDays')
          entry.key: entry.value,
      'issueDate': issued.toIso8601String(),
      'dueDate': DateTime(
        issued.year,
        issued.month,
        issued.day + (raw['termsDays']! as int),
      ).toIso8601String(),
      'payments': [
        for (final payment in (raw['payments']! as List).cast<Json>())
          {
            for (final entry in payment.entries)
              if (entry.key != 'paidAfterDays') entry.key: entry.value,
            'date': DateTime(
              issued.year,
              issued.month,
              issued.day + (payment['paidAfterDays']! as int),
            ).toIso8601String(),
          },
      ],
    };
  }

  /// A zero months-ago counts back from today (never before the month
  /// start); older months count back from that month's last day.
  DateTime _issueDate(Map issue, DateTime today) {
    final monthsAgo = issue['monthsAgo'] as int;
    final daysAgo = issue['daysAgo'] as int;
    if (monthsAgo == 0) {
      final day = DateTime(today.year, today.month, today.day - daysAgo);
      final start = DateTime(today.year, today.month);
      return day.isBefore(start) ? start : day;
    }
    final lastDay = DateTime(today.year, today.month - monthsAgo + 1, 0);
    return DateTime(lastDay.year, lastDay.month, lastDay.day - daysAgo);
  }
}
