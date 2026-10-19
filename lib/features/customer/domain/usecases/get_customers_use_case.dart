import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/customer_summary.dart';
import '../repositories/customer_repository.dart';

/// Lists the customers matching a free-text query (all when it is blank).
class GetCustomersUseCase implements UseCase<List<CustomerSummary>, String> {
  const GetCustomersUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<List<CustomerSummary>>> call(String params) =>
      _repository.getCustomers(params);
}
