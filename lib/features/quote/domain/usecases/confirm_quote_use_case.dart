import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/quote_document.dart';
import '../repositories/quote_repository.dart';

/// "Customer approved": confirms the quote and converts its deal status.
class ConfirmQuoteUseCase implements UseCase<QuoteDocument, int> {
  const ConfirmQuoteUseCase(this._repository);

  final QuoteRepository _repository;

  @override
  Future<Result<QuoteDocument>> call(int number) =>
      _repository.confirmQuote(number);
}
