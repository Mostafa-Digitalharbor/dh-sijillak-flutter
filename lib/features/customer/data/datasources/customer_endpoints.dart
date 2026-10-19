/// Paths of the customers API.
abstract final class CustomerEndpoints {
  static const customers = '/customers';
  static const customerPattern = '/customers/:id';
  static const dealsPattern = '/customers/:id/deals';
  static const invoicesPattern = '/customers/:id/invoices';

  /// Query parameter of the customers list: free-text search.
  static const queryParam = 'q';

  static String customer(String id) => '$customers/${Uri.encodeComponent(id)}';

  static String deals(String id) => '${customer(id)}/deals';

  static String invoices(String id) => '${customer(id)}/invoices';
}
