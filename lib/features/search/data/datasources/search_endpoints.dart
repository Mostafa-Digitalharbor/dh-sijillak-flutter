/// Paths of the search API.
abstract final class SearchEndpoints {
  static const search = '/search';

  /// Query parameter: the free-text query.
  static const queryParam = 'q';

  /// Keys of the response groups.
  static const customersKey = 'customers';
  static const dealsKey = 'deals';
  static const invoicesKey = 'invoices';
  static const quotesKey = 'quotes';
}
