import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/recent_searches_repository.dart';

/// Forgets every remembered query.
class ClearRecentSearchesUseCase implements UseCase<void, NoParams> {
  const ClearRecentSearchesUseCase(this._repository);

  final RecentSearchesRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.clear();
}
