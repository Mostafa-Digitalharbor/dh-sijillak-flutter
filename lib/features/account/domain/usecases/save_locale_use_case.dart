import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_language.dart';
import '../repositories/locale_repository.dart';

/// Remembers the language the user picked.
class SaveLocaleUseCase implements UseCase<void, AppLanguage> {
  const SaveLocaleUseCase(this._repository);

  final LocaleRepository _repository;

  @override
  Future<Result<void>> call(AppLanguage params) => _repository.save(params);
}
