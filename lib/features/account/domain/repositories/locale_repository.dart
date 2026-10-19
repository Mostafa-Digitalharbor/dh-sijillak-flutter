import '../../../../core/utils/result.dart';
import '../entities/app_language.dart';

/// Remembers the language the user picked.
abstract interface class LocaleRepository {
  /// The saved language, or null when none was chosen yet.
  Future<Result<AppLanguage?>> savedLanguage();

  Future<Result<void>> save(AppLanguage language);
}
