import '../../../../core/network/api_client.dart';
import '../models/deal_model.dart';
import '../models/lead_defaults_model.dart';
import '../models/new_deal_model.dart';
import '../models/pipeline_model.dart';
import 'pipeline_endpoints.dart';

/// Talks to the deals API.
abstract interface class PipelineRemoteDataSource {
  Future<PipelineModel> fetchPipeline();

  Future<LeadDefaultsModel> fetchLeadDefaults();

  Future<DealModel> createDeal(NewDealModel deal);
}

class PipelineRemoteDataSourceImpl implements PipelineRemoteDataSource {
  const PipelineRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<PipelineModel> fetchPipeline() async => PipelineModel.fromJson(
    (await _client.get(PipelineEndpoints.deals)).asJson,
  );

  @override
  Future<LeadDefaultsModel> fetchLeadDefaults() async =>
      LeadDefaultsModel.fromJson(
        (await _client.get(PipelineEndpoints.leadDefaults)).asJson,
      );

  @override
  Future<DealModel> createDeal(NewDealModel deal) async => DealModel.fromJson(
    (await _client.post(PipelineEndpoints.deals, body: deal.toJson())).asJson,
  );
}
