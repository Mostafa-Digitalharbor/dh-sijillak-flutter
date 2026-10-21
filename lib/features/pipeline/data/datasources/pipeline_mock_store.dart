import '../../../../core/network/mock/mock_assets.dart';
import '../../domain/entities/deal_stage.dart';

/// In-memory server state of the deals API, shared by every mock module that
/// touches deals (the pipeline itself, and quote approval which closes a
/// deal). One instance exists per [MockAssets], i.e. per composition root, so
/// a fresh app start (or test) starts from the fixtures again.
class PipelineMockStore {
  PipelineMockStore._(this._assets, this._clock);

  static final Expando<PipelineMockStore> _stores = Expando();

  static const _dealsAsset = 'assets/mock/pipeline/deals.json';
  static const _defaultsAsset = 'assets/mock/pipeline/lead_defaults.json';

  /// A weekday-based next step is placed at least this many days ahead.
  static const _minWeekdayLeadDays = 2;
  static const _daysPerWeek = 7;

  /// Win probability of a won deal.
  static const _wonProbability = 100;

  /// The store behind [assets]; created on first use with [clock].
  static PipelineMockStore of(
    MockAssets assets, {
    DateTime Function()? clock,
  }) => _stores[assets] ??= PipelineMockStore._(assets, clock ?? DateTime.now);

  final MockAssets _assets;
  final DateTime Function() _clock;
  Future<PipelineMockData>? _data;

  /// The loaded state (loads the fixtures on first access).
  Future<PipelineMockData> get data => _data ??= _load();

  /// Moves the deal [dealId] to the won stage, keeping the stage summaries
  /// in step. Unknown ids and already-won deals are left alone.
  Future<void> markWon(String dealId) async {
    final state = await data;
    final deal = state.deals.where((d) => d['id'] == dealId).firstOrNull;
    if (deal == null || deal['stage'] == DealStage.won.name) return;
    final value = deal['value'] as int;
    _adjust(state, deal['stage'] as String, -1, -value);
    _adjust(state, DealStage.won.name, 1, value);
    deal['stage'] = DealStage.won.name;
    deal['probability'] = _wonProbability;
  }

  /// Adds [count] deals worth [value] to the summary of [stage].
  void adjustSummary(
    PipelineMockData state,
    DealStage stage,
    int count,
    int value,
  ) => _adjust(state, stage.name, count, value);

  void _adjust(PipelineMockData state, String stage, int count, int value) {
    final summary = state.stages.firstWhere((s) => s['stage'] == stage);
    summary['count'] = (summary['count'] as int) + count;
    summary['totalValue'] = (summary['totalValue'] as int) + value;
  }

  Future<PipelineMockData> _load() async {
    final data = (await _assets.json(_dealsAsset))! as Map<String, dynamic>;
    final defaults =
        (await _assets.json(_defaultsAsset))! as Map<String, dynamic>;
    final now = _clock();
    final deals = [
      for (final raw in data['deals'] as List)
        _resolveDeal(raw as Map<String, dynamic>, now),
    ];
    final owners = <Object?, Object?>{};
    for (final deal in deals) {
      owners[deal['ownerId']] = deal['ownerName'];
    }
    final owner = defaults['owner'] as Map<String, dynamic>;
    owners[owner['id']] = owner['name'];
    return PipelineMockData(
      stages: [
        for (final stage in data['stages'] as List)
          Map<String, dynamic>.of(stage as Map<String, dynamic>),
      ],
      deals: deals,
      owners: owners,
    );
  }

  Map<String, dynamic> _resolveDeal(Map<String, dynamic> raw, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final next = raw['nextAction'] as Map<String, dynamic>?;
    final expiresInDays = raw['quoteExpiresInDays'] as int?;
    return {
      for (final entry in raw.entries)
        if (entry.key != 'nextAction' && entry.key != 'quoteExpiresInDays')
          entry.key: entry.value,
      if (next != null) 'nextAction': _resolveNextAction(next, today),
      if (expiresInDays != null)
        'quoteExpiresAt': DateTime(
          today.year,
          today.month,
          today.day + expiresInDays,
        ).toIso8601String(),
    };
  }

  Map<String, dynamic> _resolveNextAction(
    Map<String, dynamic> raw,
    DateTime today,
  ) {
    DateTime? day;
    if (raw['weekday'] != null) {
      day = today.add(const Duration(days: _minWeekdayLeadDays));
      day = DateTime(day.year, day.month, day.day);
      for (var i = 0; i < _daysPerWeek && day!.weekday != raw['weekday']; i++) {
        day = DateTime(day.year, day.month, day.day + 1);
      }
    } else if (raw['dayOffset'] != null) {
      day = DateTime(
        today.year,
        today.month,
        today.day + (raw['dayOffset'] as int),
      );
    }
    final time = (raw['time'] as String?)?.split(':');
    final at = day == null || time == null
        ? day
        : DateTime(
            day.year,
            day.month,
            day.day,
            int.parse(time[0]),
            int.parse(time[1]),
          );
    return {
      'title': raw['title'],
      if (at != null) 'at': at.toIso8601String(),
      'hasTime': time != null,
    };
  }
}

/// The mutable tables of the deals API.
class PipelineMockData {
  PipelineMockData({
    required this.stages,
    required this.deals,
    required this.owners,
  });

  final List<Map<String, dynamic>> stages;
  final List<Map<String, dynamic>> deals;

  /// Known owners by id -> display name. Customers live in the shared
  /// `CustomerMockStore`.
  final Map<Object?, Object?> owners;
  int nextId = 100;
}
