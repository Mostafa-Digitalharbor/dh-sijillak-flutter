import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/result.dart';
import '../../domain/repositories/recent_searches_repository.dart';
import '../../domain/search_rules.dart';
import '../datasources/search_text.dart';
import 'search_preferences_keys.dart';

/// Keeps the recent queries in [SharedPreferences]: most recent first,
/// without duplicates, at most [SearchRules.maxRecentSearches].
class PreferencesRecentSearchesRepository implements RecentSearchesRepository {
  const PreferencesRecentSearchesRepository(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<Result<List<String>>> recent() => Result.guard(() async => _stored());

  @override
  Future<Result<void>> save(String query) => Result.guard(() async {
    final text = query.trim();
    if (text.isEmpty) return;
    final key = SearchText.normalize(text);
    final updated = [
      text,
      ..._stored().where((entry) => SearchText.normalize(entry) != key),
    ].take(SearchRules.maxRecentSearches).toList();
    await _preferences.setStringList(SearchPreferencesKeys.recent, updated);
  });

  @override
  Future<Result<void>> clear() =>
      Result.guard(() => _preferences.remove(SearchPreferencesKeys.recent));

  List<String> _stored() =>
      _preferences.getStringList(SearchPreferencesKeys.recent) ?? const [];
}
