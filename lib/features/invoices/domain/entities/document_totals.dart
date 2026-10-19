import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_config.dart';
import 'document_line.dart';

/// Subtotal, VAT and grand total of a list of [DocumentLine]s.
class DocumentTotals extends Equatable {
  const DocumentTotals._(this.subtotal, this.vat);

  factory DocumentTotals.of(List<DocumentLine> lines) {
    final subtotal = lines.fold<int>(0, (sum, line) => sum + line.total);
    return DocumentTotals._(subtotal, subtotal * AppConfig.vatRate);
  }

  final int subtotal;
  final double vat;

  double get total => subtotal + vat;

  @override
  List<Object?> get props => [subtotal, vat];
}
