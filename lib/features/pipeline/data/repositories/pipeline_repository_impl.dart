import '../../../../core/utils/result.dart';
import '../../domain/entities/deal.dart';
import '../../domain/entities/lead_defaults.dart';
import '../../domain/entities/new_deal.dart';
import '../../domain/entities/pipeline.dart';
import '../../domain/repositories/pipeline_repository.dart';
import '../datasources/pipeline_remote_data_source.dart';
import '../models/new_deal_model.dart';

class PipelineRepositoryImpl implements PipelineRepository {
  const PipelineRepositoryImpl(this._dataSource);

  final PipelineRemoteDataSource _dataSource;

  @override
  Future<Result<Pipeline>> getPipeline() =>
      Result.guard(() async => (await _dataSource.fetchPipeline()).toEntity());

  @override
  Future<Result<LeadDefaults>> getLeadDefaults() => Result.guard(
    () async => (await _dataSource.fetchLeadDefaults()).toEntity(),
  );

  @override
  Future<Result<Deal>> createDeal(NewDeal deal) => Result.guard(
    () async =>
        (await _dataSource.createDeal(NewDealModel.fromEntity(deal)))
            .toEntity(),
  );
}
