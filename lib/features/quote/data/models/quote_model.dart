import '../../../../core/network/api_client.dart';
import '../../../invoices/data/models/document_line_model.dart';
import '../../domain/entities/quote_document.dart';

/// JSON codes of [QuoteStatus].
extension QuoteStatusCode on QuoteStatus {
  String get code => name;

  static QuoteStatus fromCode(String code) => QuoteStatus.values.firstWhere(
    (s) => s.code == code,
    orElse: () => QuoteStatus.sent,
  );
}

/// JSON mapping of a [QuoteDocument]. Only lines travel; totals and VAT are
/// computed by the domain.
abstract final class QuoteModel {
  static QuoteDocument fromJson(Json json) => QuoteDocument(
    number: (json['number'] as num).toInt(),
    customer: json['customer'] as String,
    dealTitle: json['dealTitle'] as String,
    lines: DocumentLineModel.listFromJson(json['lines']),
    dealId: json['dealId'] as String?,
    status: QuoteStatusCode.fromCode(json['status'] as String),
    viewedAt: _date(json['viewedAt']),
    validUntil: _date(json['validUntil']),
  );

  static DateTime? _date(Object? value) =>
      value == null ? null : DateTime.parse(value as String);
}
