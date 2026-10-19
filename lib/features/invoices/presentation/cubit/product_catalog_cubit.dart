import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_use_case.dart';

class ProductCatalogState extends Equatable {
  const ProductCatalogState({
    this.status = ViewStatus.initial,
    this.failure,
    this.products = const [],
  });

  final ViewStatus status;
  final Failure? failure;
  final List<Product> products;

  @override
  List<Object?> get props => [status, failure, products];
}

/// Loads the product catalog shown in the add-product sheet.
class ProductCatalogCubit extends Cubit<ProductCatalogState> {
  ProductCatalogCubit(this._getProducts) : super(const ProductCatalogState());

  final GetProductsUseCase _getProducts;

  Future<void> load() async {
    emit(const ProductCatalogState(status: ViewStatus.loading));
    final result = await _getProducts(const NoParams());
    if (isClosed) return;
    emit(
      result.when(
        success: (products) =>
            ProductCatalogState(status: ViewStatus.success, products: products),
        error: (failure) =>
            ProductCatalogState(status: ViewStatus.failure, failure: failure),
      ),
    );
  }
}
