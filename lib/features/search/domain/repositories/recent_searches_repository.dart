import '../../../../core/utils/result.dart';

/// The queries the user searched for before, kept on the device.
abstract interface class RecentSearchesRepository {
  /// Most recent first.
  Future<Result<List<String>>> recent();

  /// Remembers [query] as the latest search.
  Future<Result<void>> save(String query);

  Future<Result<void>> clear();
}
