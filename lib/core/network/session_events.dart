import 'dart:async';

/// Broadcasts session-level events raised deep in the network layer so the
/// app root can react (navigate to the welcome screen).
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  /// Fires when the backend rejected the stored credentials for good and the
  /// local session was cleared.
  Stream<void> get expired => _expired.stream;

  void notifyExpired() {
    if (!_expired.isClosed) _expired.add(null);
  }

  Future<void> dispose() => _expired.close();
}
