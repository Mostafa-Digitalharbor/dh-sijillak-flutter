import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/invoice_detail.dart';
import '../repositories/invoices_repository.dart';

/// Loads one invoice by its number.
class GetInvoiceUseCase implements UseCase<InvoiceDetail, int> {
  const GetInvoiceUseCase(this._repository);

  final InvoicesRepository _repository;

  @override
  Future<Result<InvoiceDetail>> call(int number) =>
      _repository.getInvoice(number);
}
