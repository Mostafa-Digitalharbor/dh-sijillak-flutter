import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/invoice_draft.dart';
import '../repositories/invoices_repository.dart';

/// What a new invoice starts from.
class GetInvoiceDraftParams {
  const GetInvoiceDraftParams({this.quoteNumber});

  /// Build the draft from this quote (its customer and lines) instead of the
  /// default customer and items.
  final int? quoteNumber;
}

/// Starts a new invoice: with the default customer and items, or converted
/// from a quote.
class GetInvoiceDraftUseCase
    implements UseCase<InvoiceDraft, GetInvoiceDraftParams> {
  const GetInvoiceDraftUseCase(this._repository);

  final InvoicesRepository _repository;

  @override
  Future<Result<InvoiceDraft>> call(GetInvoiceDraftParams params) =>
      _repository.getDraft(quoteNumber: params.quoteNumber);
}
