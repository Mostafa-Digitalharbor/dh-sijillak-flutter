import '../../../../core/utils/result.dart';
import '../entities/invoice_detail.dart';
import '../entities/invoice_draft.dart';
import '../entities/invoice_listing.dart';
import '../entities/invoice_period.dart';
import '../entities/invoice_summary.dart';
import '../entities/new_payment.dart';
import '../entities/product.dart';

/// Invoices, drafts and the payments recorded against them.
abstract interface class InvoicesRepository {
  /// Invoices matching [status] (all when null), the free-text [query] and
  /// issued within [period]; the overview covers the same period.
  Future<Result<InvoiceListing>> getInvoices({
    InvoiceStatus? status,
    String query = '',
    InvoicePeriod period = InvoicePeriod.allTime,
  });

  Future<Result<InvoiceDetail>> getInvoice(int number);

  /// A new draft with the default customer and items, or one converted from
  /// the quote numbered [quoteNumber].
  Future<Result<InvoiceDraft>> getDraft({int? quoteNumber});

  /// The product catalog.
  Future<Result<List<Product>>> getProducts();

  Future<Result<InvoiceDetail>> issueInvoice(InvoiceDraft draft);

  /// Records [payment]; the returned invoice reflects it (paid when settled).
  Future<Result<InvoiceDetail>> recordPayment(int number, NewPayment payment);
}
