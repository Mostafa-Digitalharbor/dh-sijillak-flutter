import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/search_results.dart';
import '../repositories/search_repository.dart';

/// Finds everything matching a free-text query.
class SearchUseCase implements UseCase<SearchResults, String> {
  const SearchUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Result<SearchResults>> call(String query) => _repository.search(query);
}
