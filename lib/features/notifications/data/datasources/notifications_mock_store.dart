import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';

/// In-memory notifications table of the mock backend. One instance exists per
/// [MockAssets], i.e. per composition root, so other mock modules can append
/// events to it and a fresh app start begins from the fixture again.
///
/// Fixture times are offsets from "now" (`minutesAgo`, or `daysAgo` plus a
/// `time` of day), so the screen always shows today / yesterday groups.
class NotificationsMockStore {
  NotificationsMockStore._(this._assets, this._clock);

  static final Expando<NotificationsMockStore> _stores = Expando();

  /// Fixture of the notifications.
  static const String asset = 'assets/mock/notifications/notifications.json';

  static const _minutesField = 'minutesAgo';
  static const _daysField = 'daysAgo';
  static const _timeField = 'time';
  static const _createdField = 'createdAt';

  /// The store behind [assets]; created on first use with [clock].
  static NotificationsMockStore of(
    MockAssets assets, {
    DateTime Function()? clock,
  }) => _stores[assets] ??= NotificationsMockStore._(
    assets,
    clock ?? DateTime.now,
  );

  final MockAssets _assets;
  final DateTime Function() _clock;
  Future<List<Json>>? _items;

  /// The notifications, newest first (loads the fixture on first access).
  Future<List<Json>> get items => _items ??= _load();

  /// Adds a new unread notification (as an event on the server would).
  Future<void> add(Json notification) async {
    (await items).insert(0, {
      ...notification,
      'isRead': false,
      _createdField: _clock().toIso8601String(),
    });
  }

  Future<List<Json>> _load() async {
    final now = _clock();
    final items =
        [
          for (final raw in (await _assets.json(asset)).asJsonList)
            _resolve(raw, now),
        ]..sort(
          (a, b) => (b[_createdField] as String).compareTo(
            a[_createdField] as String,
          ),
        );
    return items;
  }

  static Json _resolve(Json raw, DateTime now) {
    final DateTime at;
    if (raw[_minutesField] != null) {
      at = now.subtract(Duration(minutes: raw[_minutesField] as int));
    } else {
      final time = (raw[_timeField] as String).split(':');
      at = DateTime(
        now.year,
        now.month,
        now.day - (raw[_daysField] as int),
        int.parse(time[0]),
        int.parse(time[1]),
      );
    }
    return {
      for (final entry in raw.entries)
        if (entry.key != _minutesField &&
            entry.key != _daysField &&
            entry.key != _timeField)
          entry.key: entry.value,
      _createdField: at.toIso8601String(),
    };
  }
}
