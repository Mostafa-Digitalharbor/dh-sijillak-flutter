import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/crash_reporter.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/session_store.dart';
import '../models/auth_session_model.dart';
import 'session_storage_keys.dart';

/// Keeps the session, tokens included, in the platform keystore (Keychain /
/// Android Keystore) so it survives an app restart without ever touching
/// plain-text storage.
///
/// Reads are served from memory (loaded once by [open]); writes go to secure
/// storage in order, without blocking the caller. A storage that cannot be
/// read or written degrades to an in-memory session and reports the error.
class SecureSessionStore implements SessionStore {
  SecureSessionStore._(
    this._storage,
    this._reporter,
    this._current,
    this._remembered,
  );

  final FlutterSecureStorage _storage;
  final CrashReporter _reporter;
  AuthSession? _current;
  AuthSession? _remembered;
  Future<void> _pending = Future<void>.value();

  /// Loads the stored session. A session left in [legacyPreferences] by an
  /// earlier version is moved into secure storage and deleted from the
  /// preferences.
  static Future<SecureSessionStore> open({
    required FlutterSecureStorage storage,
    required SharedPreferences legacyPreferences,
    CrashReporter reporter = const ConsoleCrashReporter(),
  }) async {
    var current = await _read(storage, SessionStorageKeys.session, reporter);
    var remembered = await _read(
      storage,
      SessionStorageKeys.remembered,
      reporter,
    );
    final store = SecureSessionStore._(storage, reporter, current, remembered);
    final legacy = _readLegacy(legacyPreferences);
    if (legacy != null && current == null) {
      current = legacy;
      remembered ??= legacy;
      store
        .._current = current
        .._remembered = remembered
        .._persist();
    }
    await legacyPreferences.remove(SessionStorageKeys.legacyPreferencesSession);
    await store.flush();
    return store;
  }

  @override
  AuthSession? get current => _current;

  @override
  AuthSession? get remembered => _remembered;

  @override
  void save(AuthSession session) {
    _current = session;
    _remembered = session;
    _persist();
  }

  @override
  void clear() {
    _current = null;
    _persist();
  }

  @override
  void forgetRemembered() {
    _remembered = null;
    _persist();
  }

  /// Completes once every write issued so far has reached the storage.
  Future<void> flush() => _pending;

  void _persist() {
    final current = _current;
    final remembered = _remembered;
    _pending = _pending.then((_) async {
      try {
        await _write(SessionStorageKeys.session, current);
        await _write(SessionStorageKeys.remembered, remembered);
      } on Object catch (error, stack) {
        _reporter.record(error, stack);
      }
    });
  }

  Future<void> _write(String key, AuthSession? session) => session == null
      ? _storage.delete(key: key)
      : _storage.write(
          key: key,
          value: jsonEncode(AuthSessionModel.fromEntity(session).toJson()),
        );

  /// The session stored under [key]; corrupt or unreadable data is dropped.
  static Future<AuthSession?> _read(
    FlutterSecureStorage storage,
    String key,
    CrashReporter reporter,
  ) async {
    try {
      final raw = await storage.read(key: key);
      if (raw == null) return null;
      try {
        return _decode(raw);
      } on Object {
        await storage.delete(key: key);
        return null;
      }
    } on Object catch (error, stack) {
      reporter.record(error, stack);
      return null;
    }
  }

  static AuthSession? _readLegacy(SharedPreferences preferences) {
    final raw = preferences.getString(
      SessionStorageKeys.legacyPreferencesSession,
    );
    if (raw == null) return null;
    try {
      return _decode(raw);
    } on Object {
      return null;
    }
  }

  static AuthSession _decode(String raw) =>
      AuthSessionModel.fromJson(jsonDecode(raw) as Map<String, dynamic>)
          .toEntity();
}
