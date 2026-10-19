import '../../../../core/network/api_client.dart';
import '../../domain/entities/quote_document.dart';
import '../models/quote_model.dart';
import 'quote_endpoints.dart';

/// Calls the quotes API; throws `AppException`s on failure.
abstract interface class QuoteRemoteDataSource {
  Future<QuoteDocument> getQuote(int number);

  Future<QuoteDocument> confirmQuote(int number);

  Future<QuoteDocument> createQuoteForDeal(String dealId);
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  const QuoteRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<QuoteDocument> getQuote(int number) async => QuoteModel.fromJson(
    (await _client.get(QuoteEndpoints.quote(number))).asJson,
  );

  @override
  Future<QuoteDocument> confirmQuote(int number) async => QuoteModel.fromJson(
    (await _client.post(QuoteEndpoints.approve(number))).asJson,
  );

  @override
  Future<QuoteDocument> createQuoteForDeal(String dealId) async =>
      QuoteModel.fromJson(
        (await _client.post(QuoteEndpoints.dealQuotes(dealId))).asJson,
      );
}
