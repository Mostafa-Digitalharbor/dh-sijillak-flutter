import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/usecases/get_saved_locale_use_case.dart';
import '../../domain/usecases/save_locale_use_case.dart';

/// The active app language; switching it persists the choice.
class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit(this._save, {required AppLanguage initial}) : super(initial);

  /// Starts on the saved language, else on [fallback].
  static Future<LocaleCubit> restore(
    GetSavedLocaleUseCase getSaved,
    SaveLocaleUseCase save, {
    required AppLanguage fallback,
  }) async {
    final saved = (await getSaved(const NoParams())).dataOrNull;
    return LocaleCubit(save, initial: saved ?? fallback);
  }

  final SaveLocaleUseCase _save;

  Future<void> select(AppLanguage language) async {
    if (language == state) return;
    emit(language);
    await _save(language);
  }
}
