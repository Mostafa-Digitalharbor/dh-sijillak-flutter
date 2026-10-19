import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/quote_document.dart';
import '../repositories/quote_repository.dart';

/// Creates the quote of a deal (param: the deal id) from the deal's data.
class CreateQuoteForDealUseCase implements UseCase<QuoteDocument, String> {
  const CreateQuoteForDealUseCase(this._repository);

  final QuoteRepository _repository;

  @override
  Future<Result<QuoteDocument>> call(String dealId) =>
      _repository.createQuoteForDeal(dealId);
}
