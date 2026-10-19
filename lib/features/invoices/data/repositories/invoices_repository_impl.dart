import '../../../../core/utils/result.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/entities/invoice_listing.dart';
import '../../domain/entities/invoice_period.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/new_payment.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/invoices_repository.dart';
import '../datasources/invoices_remote_data_source.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  const InvoicesRepositoryImpl(this._remote);

  final InvoicesRemoteDataSource _remote;

  @override
  Future<Result<InvoiceListing>> getInvoices({
    InvoiceStatus? status,
    String query = '',
    InvoicePeriod period = InvoicePeriod.allTime,
  }) => Result.guard(
    () => _remote.getInvoices(status: status, query: query, period: period),
  );

  @override
  Future<Result<InvoiceDetail>> getInvoice(int number) =>
      Result.guard(() => _remote.getInvoice(number));

  @override
  Future<Result<InvoiceDraft>> getDraft({int? quoteNumber}) =>
      Result.guard(() => _remote.getDraft(quoteNumber: quoteNumber));

  @override
  Future<Result<List<Product>>> getProducts() =>
      Result.guard(_remote.getProducts);

  @override
  Future<Result<InvoiceDetail>> issueInvoice(InvoiceDraft draft) =>
      Result.guard(() => _remote.issueInvoice(draft));

  @override
  Future<Result<InvoiceDetail>> recordPayment(int number, NewPayment payment) =>
      Result.guard(() => _remote.recordPayment(number, payment));
}
