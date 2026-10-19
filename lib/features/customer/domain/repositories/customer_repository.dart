import '../../../../core/utils/result.dart';
import '../entities/customer.dart';
import '../entities/customer_deal.dart';
import '../entities/customer_invoice.dart';
import '../entities/customer_summary.dart';

/// Source of customer profiles and lists.
abstract interface class CustomerRepository {
  /// Customers whose name or location contains [query] (all when blank).
  Future<Result<List<CustomerSummary>>> getCustomers(String query);

  Future<Result<Customer>> getCustomer(String id);

  /// The pipeline deals of customer [id].
  Future<Result<List<CustomerDeal>>> getDeals(String id);

  /// The invoices issued to customer [id], newest first.
  Future<Result<List<CustomerInvoice>>> getInvoices(String id);
}
