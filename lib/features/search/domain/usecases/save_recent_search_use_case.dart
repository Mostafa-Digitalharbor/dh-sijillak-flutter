import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/recent_searches_repository.dart';

/// Remembers a query the user acted on.
class SaveRecentSearchUseCase implements UseCase<void, String> {
  const SaveRecentSearchUseCase(this._repository);

  final RecentSearchesRepository _repository;

  @override
  Future<Result<void>> call(String query) => _repository.save(query);
}
