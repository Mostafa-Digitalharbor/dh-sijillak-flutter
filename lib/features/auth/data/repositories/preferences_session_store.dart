import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/session_store.dart';
import '../models/auth_session_model.dart';
import 'session_preferences_keys.dart';

/// Keeps the session on the device so it survives an app restart.
///
/// Reads are served from memory (loaded once at construction); writes go to
/// [SharedPreferences] without blocking the caller.
class PreferencesSessionStore implements SessionStore {
  PreferencesSessionStore(this._preferences) : _current = _read(_preferences);

  final SharedPreferences _preferences;
  AuthSession? _current;

  @override
  AuthSession? get current => _current;

  @override
  void save(AuthSession session) {
    _current = session;
    _preferences.setString(
      SessionPreferencesKeys.session,
      jsonEncode(AuthSessionModel.fromEntity(session).toJson()),
    );
  }

  @override
  void clear() {
    _current = null;
    _preferences.remove(SessionPreferencesKeys.session);
  }

  /// The stored session, or null when absent or unreadable.
  static AuthSession? _read(SharedPreferences preferences) {
    final raw = preferences.getString(SessionPreferencesKeys.session);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AuthSessionModel.fromJson(json).toEntity();
    } on Object {
      preferences.remove(SessionPreferencesKeys.session);
      return null;
    }
  }
}
