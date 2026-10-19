import '../../domain/entities/invoice_summary.dart';

/// JSON codes of [InvoiceStatus].
extension InvoiceStatusCode on InvoiceStatus {
  String get code => name;

  static InvoiceStatus fromCode(String code) => InvoiceStatus.values.firstWhere(
    (s) => s.code == code,
    orElse: () => InvoiceStatus.due,
  );
}
