import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/recent_searches_repository.dart';

/// Loads the remembered queries, most recent first.
class GetRecentSearchesUseCase implements UseCase<List<String>, NoParams> {
  const GetRecentSearchesUseCase(this._repository);

  final RecentSearchesRepository _repository;

  @override
  Future<Result<List<String>>> call(NoParams params) => _repository.recent();
}
