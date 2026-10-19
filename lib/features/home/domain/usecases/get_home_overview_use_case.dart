import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/home_overview.dart';
import '../repositories/home_repository.dart';

/// Loads the dashboard: sales summary, due invoices, open deals and today's
/// tasks.
class GetHomeOverviewUseCase implements UseCase<HomeOverview, NoParams> {
  const GetHomeOverviewUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<HomeOverview>> call(NoParams params) =>
      _repository.getOverview();
}
