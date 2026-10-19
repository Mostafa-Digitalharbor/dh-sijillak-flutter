import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

/// Loads one customer: profile, headline figures and activity timeline. The
/// parameter is the customer id.
class GetCustomerUseCase implements UseCase<Customer, String> {
  const GetCustomerUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<Customer>> call(String params) =>
      _repository.getCustomer(params);
}
