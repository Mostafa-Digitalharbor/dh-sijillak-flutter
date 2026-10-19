import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/lead_defaults.dart';
import '../repositories/pipeline_repository.dart';

/// Loads the customer and owner the new-deal form starts with.
class GetLeadDefaultsUseCase implements UseCase<LeadDefaults, NoParams> {
  const GetLeadDefaultsUseCase(this._repository);

  final PipelineRepository _repository;

  @override
  Future<Result<LeadDefaults>> call(NoParams params) =>
      _repository.getLeadDefaults();
}
