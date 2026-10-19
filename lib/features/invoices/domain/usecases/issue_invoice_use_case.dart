import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/document_line.dart';
import '../entities/invoice_detail.dart';
import '../entities/invoice_draft.dart';
import '../repositories/invoices_repository.dart';

/// Issues an [InvoiceDraft] as a real invoice. Lines whose quantity was
/// reduced to zero are dropped; a draft with nothing left is rejected.
class IssueInvoiceUseCase implements UseCase<InvoiceDetail, InvoiceDraft> {
  const IssueInvoiceUseCase(this._repository);

  static const String linesField = 'lines';
  static const String emptyCode = 'empty';

  final InvoicesRepository _repository;

  @override
  Future<Result<InvoiceDetail>> call(InvoiceDraft draft) async {
    final lines = <DocumentLine>[
      for (final line in draft.lines)
        if (line.quantity > 0) line,
    ];
    if (lines.isEmpty) {
      return const Failed(ValidationFailure(fields: {linesField: emptyCode}));
    }
    return _repository.issueInvoice(draft.withLines(lines));
  }
}
