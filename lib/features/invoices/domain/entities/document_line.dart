import 'package:equatable/equatable.dart';

/// One priced line of a quote or an invoice.
class DocumentLine extends Equatable {
  const DocumentLine({
    required this.name,
    required this.unitPrice,
    this.quantity = 1,
  });

  final String name;
  final int unitPrice;
  final int quantity;

  int get total => unitPrice * quantity;

  DocumentLine withQuantity(int quantity) =>
      DocumentLine(name: name, unitPrice: unitPrice, quantity: quantity);

  @override
  List<Object?> get props => [name, unitPrice, quantity];
}
