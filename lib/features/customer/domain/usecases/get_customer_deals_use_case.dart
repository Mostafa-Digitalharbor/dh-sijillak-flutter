import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/customer_deal.dart';
import '../repositories/customer_repository.dart';

/// Loads the deals of one customer. The parameter is the customer id.
class GetCustomerDealsUseCase implements UseCase<List<CustomerDeal>, String> {
  const GetCustomerDealsUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<List<CustomerDeal>>> call(String params) =>
      _repository.getDeals(params);
}
