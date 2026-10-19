import '../../../../core/network/api_client.dart';
import '../../domain/entities/invoice_draft.dart';
import 'document_line_model.dart';

/// JSON mapping of an [InvoiceDraft], both as a response and as the body of
/// the issue request (lines only, no totals).
abstract final class InvoiceDraftModel {
  static InvoiceDraft fromJson(Json json) => InvoiceDraft(
    customer: json['customer'] as String,
    vatNumber: json['vatNumber'] as String,
    issueDate: DateTime.parse(json['issueDate'] as String),
    paymentTermsDays: (json['paymentTermsDays'] as num).toInt(),
    lines: DocumentLineModel.listFromJson(json['lines']),
  );

  static Json toJson(InvoiceDraft draft) => {
    'customer': draft.customer,
    'vatNumber': draft.vatNumber,
    'issueDate': draft.issueDate.toIso8601String(),
    'paymentTermsDays': draft.paymentTermsDays,
    'lines': [for (final line in draft.lines) DocumentLineModel.toJson(line)],
  };
}
