import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/customer_invoice.dart';
import '../repositories/customer_repository.dart';

/// Loads the invoices of one customer. The parameter is the customer id.
class GetCustomerInvoicesUseCase
    implements UseCase<List<CustomerInvoice>, String> {
  const GetCustomerInvoicesUseCase(this._repository);

  final CustomerRepository _repository;

  @override
  Future<Result<List<CustomerInvoice>>> call(String params) =>
      _repository.getInvoices(params);
}
