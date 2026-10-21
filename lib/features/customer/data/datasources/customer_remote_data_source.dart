import '../../../../core/network/api_client.dart';
import '../models/customer_deal_model.dart';
import '../models/customer_invoice_model.dart';
import '../models/customer_model.dart';
import '../models/customer_summary_model.dart';
import '../models/new_customer_model.dart';
import 'customer_endpoints.dart';

/// Talks to the customers API.
abstract interface class CustomerRemoteDataSource {
  Future<List<CustomerSummaryModel>> fetchCustomers(String query);

  Future<CustomerModel> fetchCustomer(String id);

  Future<CustomerModel> createCustomer(NewCustomerModel customer);

  Future<List<CustomerDealModel>> fetchDeals(String id);

  Future<List<CustomerInvoiceModel>> fetchInvoices(String id);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  const CustomerRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<CustomerSummaryModel>> fetchCustomers(String query) async {
    final text = query.trim();
    final rows = await _client.get(
      CustomerEndpoints.customers,
      query: {if (text.isNotEmpty) CustomerEndpoints.queryParam: text},
    );
    return [
      for (final row in rows.asJsonList) CustomerSummaryModel.fromJson(row),
    ];
  }

  @override
  Future<CustomerModel> fetchCustomer(String id) async =>
      CustomerModel.fromJson(
        (await _client.get(CustomerEndpoints.customer(id))).asJson,
      );

  @override
  Future<CustomerModel> createCustomer(NewCustomerModel customer) async =>
      CustomerModel.fromJson(
        (await _client.post(
          CustomerEndpoints.customers,
          body: customer.toJson(),
        )).asJson,
      );

  @override
  Future<List<CustomerDealModel>> fetchDeals(String id) async => [
    for (final row in (await _client.get(
      CustomerEndpoints.deals(id),
    )).asJsonList)
      CustomerDealModel.fromJson(row),
  ];

  @override
  Future<List<CustomerInvoiceModel>> fetchInvoices(String id) async => [
    for (final row in (await _client.get(
      CustomerEndpoints.invoices(id),
    )).asJsonList)
      CustomerInvoiceModel.fromJson(row),
  ];
}
