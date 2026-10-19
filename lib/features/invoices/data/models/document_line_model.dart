import '../../../../core/network/api_client.dart';
import '../../domain/entities/document_line.dart';

/// JSON form of a [DocumentLine]: only name, unit price and quantity travel;
/// totals and VAT are computed by the domain.
abstract final class DocumentLineModel {
  static DocumentLine fromJson(Json json) => DocumentLine(
    name: json['name'] as String,
    unitPrice: (json['unitPrice'] as num).toInt(),
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  );

  static Json toJson(DocumentLine line) => {
    'name': line.name,
    'unitPrice': line.unitPrice,
    'quantity': line.quantity,
  };

  static List<DocumentLine> listFromJson(Object? json) => [
    for (final line in (json! as List).cast<Json>()) fromJson(line),
  ];
}
