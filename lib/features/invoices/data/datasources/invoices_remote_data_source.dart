import '../../../../core/network/api_client.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/entities/invoice_listing.dart';
import '../../domain/entities/invoice_period.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/new_payment.dart';
import '../../domain/entities/product.dart';
import '../models/invoice_detail_model.dart';
import '../models/invoice_draft_model.dart';
import '../models/invoice_listing_model.dart';
import '../models/invoice_period_code.dart';
import '../models/invoice_status_code.dart';
import '../models/payment_model.dart';
import '../models/product_model.dart';
import 'invoices_endpoints.dart';

/// Calls the invoices API; throws `AppException`s on failure.
abstract interface class InvoicesRemoteDataSource {
  Future<InvoiceListing> getInvoices({
    InvoiceStatus? status,
    String query,
    InvoicePeriod period,
  });

  Future<InvoiceDetail> getInvoice(int number);

  Future<InvoiceDraft> getDraft({int? quoteNumber});

  Future<List<Product>> getProducts();

  Future<InvoiceDetail> issueInvoice(InvoiceDraft draft);

  Future<InvoiceDetail> recordPayment(int number, NewPayment payment);
}

class InvoicesRemoteDataSourceImpl implements InvoicesRemoteDataSource {
  const InvoicesRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<InvoiceListing> getInvoices({
    InvoiceStatus? status,
    String query = '',
    InvoicePeriod period = InvoicePeriod.allTime,
  }) async {
    final response = await _client.get(
      InvoicesEndpoints.invoices,
      query: {
        if (status != null) InvoicesEndpoints.statusParam: status.code,
        if (query.isNotEmpty) InvoicesEndpoints.queryParam: query,
        if (period != InvoicePeriod.allTime)
          InvoicesEndpoints.periodParam: period.code,
      },
    );
    return InvoiceListingModel.fromJson(response.asJson);
  }

  @override
  Future<InvoiceDetail> getInvoice(int number) async =>
      InvoiceDetailModel.fromJson(
        (await _client.get(InvoicesEndpoints.invoice(number))).asJson,
      );

  @override
  Future<InvoiceDraft> getDraft({int? quoteNumber}) async =>
      InvoiceDraftModel.fromJson(
        (await _client.get(
          InvoicesEndpoints.draft,
          query: {
            if (quoteNumber != null)
              InvoicesEndpoints.quoteParam: '$quoteNumber',
          },
        )).asJson,
      );

  @override
  Future<List<Product>> getProducts() async =>
      ProductModel.listFromJson(await _client.get(InvoicesEndpoints.products));

  @override
  Future<InvoiceDetail> issueInvoice(InvoiceDraft draft) async =>
      InvoiceDetailModel.fromJson(
        (await _client.post(
          InvoicesEndpoints.invoices,
          body: InvoiceDraftModel.toJson(draft),
        )).asJson,
      );

  @override
  Future<InvoiceDetail> recordPayment(int number, NewPayment payment) async =>
      InvoiceDetailModel.fromJson(
        (await _client.post(
          InvoicesEndpoints.payments(number),
          body: PaymentModel.toJson(payment),
        )).asJson,
      );
}
