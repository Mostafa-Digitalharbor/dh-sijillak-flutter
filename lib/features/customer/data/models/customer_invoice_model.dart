import '../../../invoices/data/models/invoice_status_code.dart';
import '../../../invoices/domain/entities/invoice_summary.dart';
import '../../domain/entities/customer_invoice.dart';

/// Wire format of one row of GET /customers/:id/invoices.
class CustomerInvoiceModel {
  const CustomerInvoiceModel({
    required this.number,
    required this.date,
    required this.amount,
    required this.status,
  });

  factory CustomerInvoiceModel.fromJson(Map<String, dynamic> json) =>
      CustomerInvoiceModel(
        number: (json['number'] as num).toInt(),
        date: DateTime.parse(json['date'] as String),
        amount: (json['amount'] as num).toInt(),
        status: InvoiceStatusCode.fromCode(json['status'] as String),
      );

  final int number;
  final DateTime date;
  final int amount;
  final InvoiceStatus status;

  Map<String, dynamic> toJson() => {
    'number': number,
    'date': date.toIso8601String(),
    'amount': amount,
    'status': status.code,
  };

  CustomerInvoice toEntity() => CustomerInvoice(
    number: number,
    date: date,
    amount: amount,
    status: status,
  );
}
