import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/repositories/locale_repository.dart';
import 'locale_preferences_keys.dart';

/// Stores the chosen language in [SharedPreferences].
class PreferencesLocaleRepository implements LocaleRepository {
  const PreferencesLocaleRepository(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<Result<AppLanguage?>> savedLanguage() => Result.guard(
    () async => AppLanguage.fromCode(
      _preferences.getString(LocalePreferencesKeys.language),
    ),
  );

  @override
  Future<Result<void>> save(AppLanguage language) => Result.guard(
    () => _preferences.setString(LocalePreferencesKeys.language, language.code),
  );
}
