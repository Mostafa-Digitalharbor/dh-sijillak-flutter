import '../../../../core/network/api_client.dart';
import '../models/home_overview_model.dart';
import 'home_endpoints.dart';

/// Talks to the home API.
abstract interface class HomeRemoteDataSource {
  Future<HomeOverviewModel> fetchOverview();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<HomeOverviewModel> fetchOverview() async => HomeOverviewModel.fromJson(
    (await _client.get(HomeEndpoints.overview)).asJson,
  );
}
