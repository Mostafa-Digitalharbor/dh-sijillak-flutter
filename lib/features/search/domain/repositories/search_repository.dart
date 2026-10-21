import '../../../../core/utils/result.dart';
import '../entities/search_results.dart';

/// Searches the workspace's customers, deals, invoices and quotes.
abstract interface class SearchRepository {
  Future<Result<SearchResults>> search(String query);
}
