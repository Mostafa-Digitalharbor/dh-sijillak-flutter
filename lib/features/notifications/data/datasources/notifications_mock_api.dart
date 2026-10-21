import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import 'notifications_endpoints.dart';
import 'notifications_mock_store.dart';

/// Fake notifications backend: the fixture plus in-memory read flags, so
/// opening a notification lowers the unread count in later reads.
class NotificationsMockApi implements MockApiModule {
  NotificationsMockApi(MockAssets assets, {DateTime Function()? clock})
    : _store = NotificationsMockStore.of(assets, clock: clock);

  static const _readField = 'isRead';
  static const _idField = 'id';
  static const _countField = 'count';

  final NotificationsMockStore _store;

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, NotificationsEndpoints.notifications, _list),
    MockRoute(HttpMethod.get, NotificationsEndpoints.unreadCount, _unread),
    MockRoute(HttpMethod.post, NotificationsEndpoints.readPattern, _read),
    MockRoute(HttpMethod.post, NotificationsEndpoints.readAll, _readAll),
  ];

  Future<Object?> _list(MockRequest request) => _store.items;

  Future<Object?> _unread(MockRequest request) async => {
    _countField: (await _store.items).where(_isUnread).length,
  };

  Future<Object?> _read(MockRequest request) async {
    final id = request.pathParams[NotificationsEndpoints.idParam];
    final item = (await _store.items).firstWhere(
      (n) => n[_idField] == id,
      orElse: () => throw NotFoundException('notification $id'),
    );
    item[_readField] = true;
    return item;
  }

  Future<Object?> _readAll(MockRequest request) async {
    for (final item in await _store.items) {
      item[_readField] = true;
    }
    return {_countField: 0};
  }

  static bool _isUnread(Json n) => n[_readField] != true;
}
