import '../../../../core/utils/result.dart';
import '../../domain/entities/quote_document.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_data_source.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  const QuoteRepositoryImpl(this._remote);

  final QuoteRemoteDataSource _remote;

  @override
  Future<Result<QuoteDocument>> getQuote(int number) =>
      Result.guard(() => _remote.getQuote(number));

  @override
  Future<Result<QuoteDocument>> confirmQuote(int number) =>
      Result.guard(() => _remote.confirmQuote(number));

  @override
  Future<Result<QuoteDocument>> createQuoteForDeal(String dealId) =>
      Result.guard(() => _remote.createQuoteForDeal(dealId));
}
