import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/pipeline.dart';
import '../repositories/pipeline_repository.dart';

/// Loads the deals grouped by stage with per-stage counts and totals.
class GetPipelineUseCase implements UseCase<Pipeline, NoParams> {
  const GetPipelineUseCase(this._repository);

  final PipelineRepository _repository;

  @override
  Future<Result<Pipeline>> call(NoParams params) => _repository.getPipeline();
}
