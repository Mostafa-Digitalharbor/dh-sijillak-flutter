import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/quote_document.dart';
import '../repositories/quote_repository.dart';

/// Loads one quote by its number.
class GetQuoteUseCase implements UseCase<QuoteDocument, int> {
  const GetQuoteUseCase(this._repository);

  final QuoteRepository _repository;

  @override
  Future<Result<QuoteDocument>> call(int number) =>
      _repository.getQuote(number);
}
