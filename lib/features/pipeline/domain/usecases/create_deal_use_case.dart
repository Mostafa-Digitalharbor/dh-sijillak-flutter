import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/deal.dart';
import '../entities/new_deal.dart';
import '../repositories/pipeline_repository.dart';

/// Opens a new deal from the New Lead form.
class CreateDealUseCase implements UseCase<Deal, NewDeal> {
  const CreateDealUseCase(this._repository);

  final PipelineRepository _repository;

  @override
  Future<Result<Deal>> call(NewDeal params) => _repository.createDeal(params);
}
