import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_language.dart';
import '../repositories/locale_repository.dart';

/// The language the user picked earlier, or null when none was chosen.
class GetSavedLocaleUseCase implements UseCase<AppLanguage?, NoParams> {
  const GetSavedLocaleUseCase(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Result<AppLanguage?>> call(NoParams params) =>
      _repository.savedLanguage();
}
