import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/customer.dart';
import '../entities/new_customer.dart';
import '../repositories/customer_repository.dart';

/// Adds a customer and returns the created profile.
class CreateCustomerUseCase implements UseCase<Customer, NewCustomer> {
  const CreateCustomerUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<Customer>> call(NewCustomer params) =>
      _repository.createCustomer(params);
}
