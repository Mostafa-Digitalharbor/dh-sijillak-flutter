import '../../../../core/utils/result.dart';
import '../entities/deal.dart';
import '../entities/lead_defaults.dart';
import '../entities/new_deal.dart';
import '../entities/pipeline.dart';

/// Source of the deals pipeline.
abstract interface class PipelineRepository {
  Future<Result<Pipeline>> getPipeline();

  Future<Result<LeadDefaults>> getLeadDefaults();

  Future<Result<Deal>> createDeal(NewDeal deal);
}
