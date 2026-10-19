import '../../domain/entities/invoice_period.dart';

/// Query-string codes of [InvoicePeriod].
extension InvoicePeriodCode on InvoicePeriod {
  String get code => name;

  static InvoicePeriod fromCode(String? code) => InvoicePeriod.values
      .firstWhere((p) => p.code == code, orElse: () => InvoicePeriod.allTime);
}
