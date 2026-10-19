import 'package:equatable/equatable.dart';

import 'document_line.dart';

/// A catalog item that can be put on an invoice.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.unitPrice,
  });

  final String id;
  final String name;
  final int unitPrice;

  /// This product as an invoice line of [quantity] units.
  DocumentLine toLine({int quantity = 1}) =>
      DocumentLine(name: name, unitPrice: unitPrice, quantity: quantity);

  @override
  List<Object?> get props => [id, name, unitPrice];
}
