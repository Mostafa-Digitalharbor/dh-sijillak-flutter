import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import 'home_endpoints.dart';

/// Fake home endpoints served by the mock backend. Task times in the fixture
/// are offsets from the current day, so the dashboard always shows tasks for
/// the day it is opened.
class HomeMockApi implements MockApiModule {
  HomeMockApi(this._assets, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  static const _overviewAsset = 'assets/mock/home/overview.json';

  final MockAssets _assets;
  final DateTime Function() _clock;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, HomeEndpoints.overview, (_) => _overview()),
  ];

  Future<Object?> _overview() async {
    final data = (await _assets.json(_overviewAsset))! as Map<String, dynamic>;
    final now = _clock();
    return {
      ...data,
      'tasks': [
        for (final raw in data['tasks'] as List)
          _resolveTask(raw as Map<String, dynamic>, now),
      ],
    };
  }

  static Map<String, dynamic> _resolveTask(
    Map<String, dynamic> raw,
    DateTime now,
  ) {
    final parts = (raw['time'] as String).split(':');
    final at = DateTime(
      now.year,
      now.month,
      now.day + (raw['dayOffset'] as int),
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    return {
      for (final entry in raw.entries)
        if (entry.key != 'dayOffset' && entry.key != 'time')
          entry.key: entry.value,
      'scheduledAt': at.toIso8601String(),
    };
  }
}
