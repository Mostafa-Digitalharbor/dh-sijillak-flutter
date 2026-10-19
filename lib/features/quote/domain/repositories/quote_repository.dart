import '../../../../core/utils/result.dart';
import '../entities/quote_document.dart';

/// Quotes sent to customers and their approval.
abstract interface class QuoteRepository {
  Future<Result<QuoteDocument>> getQuote(int number);

  /// Marks the quote as approved by the customer; the linked deal is
  /// converted along with it. Returns the updated quote.
  Future<Result<QuoteDocument>> confirmQuote(int number);

  /// Creates the quote for the deal [dealId] and returns it; asking again for
  /// the same deal returns the quote that already exists.
  Future<Result<QuoteDocument>> createQuoteForDeal(String dealId);
}
