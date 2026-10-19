/// Paths of the quotes API.
abstract final class QuoteEndpoints {
  static String quote(int number) => '/quotes/$number';

  static String approve(int number) => '/quotes/$number/approve';

  static String dealQuotes(String dealId) => '/deals/$dealId/quotes';

  /// Route patterns with a `:number` parameter, for the mock backend.
  static const String quotePattern = '/quotes/:number';
  static const String approvePattern = '/quotes/:number/approve';
  static const String dealQuotesPattern = '/deals/:dealId/quotes';
  static const String numberParam = 'number';
  static const String dealIdParam = 'dealId';
}
