import '../../../../core/network/api_client.dart';
import '../../domain/entities/invoice_detail.dart';
import 'document_line_model.dart';
import 'invoice_status_code.dart';
import 'payment_model.dart';

/// JSON mapping of an [InvoiceDetail]. The wire form carries lines and
/// payments only; totals are never sent.
abstract final class InvoiceDetailModel {
  static InvoiceDetail fromJson(Json json) => InvoiceDetail(
    number: (json['number'] as num).toInt(),
    customer: json['customer'] as String,
    vatNumber: json['vatNumber'] as String,
    issueDate: DateTime.parse(json['issueDate'] as String),
    dueDate: DateTime.parse(json['dueDate'] as String),
    lines: DocumentLineModel.listFromJson(json['lines']),
    status: InvoiceStatusCode.fromCode(json['status'] as String),
    payments: [
      for (final payment in ((json['payments'] as List?) ?? const []))
        PaymentModel.fromJson((payment as Map).cast<String, dynamic>()),
    ],
  );
}
