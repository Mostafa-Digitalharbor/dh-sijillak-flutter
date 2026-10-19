import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/invoice_listing.dart';
import '../entities/invoice_period.dart';
import '../entities/invoice_summary.dart';
import '../repositories/invoices_repository.dart';

/// Filter of the invoices list.
class GetInvoicesParams {
  const GetInvoicesParams({
    this.status,
    this.query = '',
    this.period = InvoicePeriod.allTime,
  });

  /// Only invoices in this status; null lists every invoice.
  final InvoiceStatus? status;

  /// Free text matched against customer name and invoice number.
  final String query;

  /// Only invoices issued in this period.
  final InvoicePeriod period;
}

/// Loads the invoices list and the billing overview.
class GetInvoicesUseCase implements UseCase<InvoiceListing, GetInvoicesParams> {
  const GetInvoicesUseCase(this._repository);

  final InvoicesRepository _repository;

  @override
  Future<Result<InvoiceListing>> call(GetInvoicesParams params) =>
      _repository.getInvoices(
        status: params.status,
        query: params.query,
        period: params.period,
      );
}
