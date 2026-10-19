import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/product.dart';
import '../repositories/invoices_repository.dart';

/// Loads the product catalog offered when adding an invoice line.
class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  const GetProductsUseCase(this._repository);

  final InvoicesRepository _repository;

  @override
  Future<Result<List<Product>>> call(NoParams params) =>
      _repository.getProducts();
}
