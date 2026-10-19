/// Paths of the invoices API.
abstract final class InvoicesEndpoints {
  static const String statusParam = 'status';
  static const String queryParam = 'q';
  static const String periodParam = 'period';
  static const String quoteParam = 'quote';

  static const String invoices = '/invoices';
  static const String draft = '/invoices/draft';
  static const String products = '/products';

  static String invoice(int number) => '/invoices/$number';

  static String payments(int number) => '/invoices/$number/payments';

  /// Route pattern with a `:number` parameter, for the mock backend.
  static const String invoicePattern = '/invoices/:number';
  static const String paymentsPattern = '/invoices/:number/payments';
  static const String numberParam = 'number';
}
