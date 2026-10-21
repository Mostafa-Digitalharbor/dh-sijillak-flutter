import '../../../../core/network/api_client.dart';
import '../../domain/entities/search_results.dart';
import '../models/search_results_model.dart';
import 'search_endpoints.dart';

/// Talks to the search API.
abstract interface class SearchRemoteDataSource {
  Future<SearchResults> search(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<SearchResults> search(String query) async {
    final payload = await _client.get(
      SearchEndpoints.search,
      query: {SearchEndpoints.queryParam: query.trim()},
    );
    return SearchResultsModel.fromJson(payload.asJson);
  }
}
