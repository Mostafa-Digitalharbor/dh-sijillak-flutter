import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/features/account/data/repositories/locale_preferences_keys.dart';
import 'package:sijilak/features/account/data/repositories/preferences_locale_repository.dart';
import 'package:sijilak/features/account/domain/entities/app_language.dart';
import 'package:sijilak/features/account/domain/usecases/get_saved_locale_use_case.dart';
import 'package:sijilak/features/account/domain/usecases/save_locale_use_case.dart';
import 'package:sijilak/features/account/presentation/cubit/locale_cubit.dart';

typedef _Setup = ({
  GetSavedLocaleUseCase get,
  SaveLocaleUseCase save,
  SharedPreferences prefs,
});

Future<_Setup> _setup([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  final repository = PreferencesLocaleRepository(prefs);
  return (
    get: GetSavedLocaleUseCase(repository),
    save: SaveLocaleUseCase(repository),
    prefs: prefs,
  );
}

void main() {
  group('AppLanguage.fromCode', () {
    test('maps known codes and rejects others', () {
      expect(AppLanguage.fromCode('ar'), AppLanguage.arabic);
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode('fr'), isNull);
      expect(AppLanguage.fromCode(null), isNull);
    });
  });

  group('locale use cases', () {
    test('nothing saved yet -> null', () async {
      final s = await _setup();
      expect((await s.get(const NoParams())).dataOrNull, isNull);
    });

    test('save then get returns the language and writes the key', () async {
      final s = await _setup();
      expect((await s.save(AppLanguage.english)).isSuccess, isTrue);
      expect(
        s.prefs.getString(LocalePreferencesKeys.language),
        AppLanguage.english.code,
      );
      expect((await s.get(const NoParams())).dataOrNull, AppLanguage.english);
    });

    test('an unsupported stored code reads as not chosen', () async {
      final s = await _setup({LocalePreferencesKeys.language: 'xx'});
      expect((await s.get(const NoParams())).dataOrNull, isNull);
    });
  });

  group('LocaleCubit', () {
    test('restores the saved language', () async {
      final s = await _setup({LocalePreferencesKeys.language: 'en'});
      final cubit = await LocaleCubit.restore(
        s.get,
        s.save,
        fallback: AppLanguage.arabic,
      );
      expect(cubit.state, AppLanguage.english);
      await cubit.close();
    });

    test('falls back when nothing is saved', () async {
      final s = await _setup();
      final cubit = await LocaleCubit.restore(
        s.get,
        s.save,
        fallback: AppLanguage.arabic,
      );
      expect(cubit.state, AppLanguage.arabic);
      await cubit.close();
    });

    test('select emits and persists, surviving a restart', () async {
      final s = await _setup();
      final cubit = LocaleCubit(s.save, initial: AppLanguage.arabic);
      await cubit.select(AppLanguage.english);
      expect(cubit.state, AppLanguage.english);
      final restarted = await LocaleCubit.restore(
        s.get,
        s.save,
        fallback: AppLanguage.arabic,
      );
      expect(restarted.state, AppLanguage.english);
      await cubit.close();
      await restarted.close();
    });
  });
}
