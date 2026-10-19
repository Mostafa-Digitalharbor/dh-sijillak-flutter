import '../../../../core/network/api_client.dart';
import '../../domain/entities/product.dart';

/// JSON mapping of a catalog [Product].
abstract final class ProductModel {
  static Product fromJson(Json json) => Product(
    id: json['id'] as String,
    name: json['name'] as String,
    unitPrice: (json['unitPrice'] as num).toInt(),
  );

  static List<Product> listFromJson(Object? json) => [
    for (final product in (json! as List).cast<Json>()) fromJson(product),
  ];
}
