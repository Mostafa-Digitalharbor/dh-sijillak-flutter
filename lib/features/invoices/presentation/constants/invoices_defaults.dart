import '../../domain/entities/invoice_period.dart';

/// Invoice numbers used when a route is opened without one (for example a
/// deep link to the bare screen), and list defaults.
abstract final class InvoicesDefaults {
  /// Invoice shown by the detail screen.
  static const int invoiceNumber = 391;

  /// Invoice whose recorded payment the confirmation screen shows.
  static const int paidInvoiceNumber = 392;

  /// Period the invoices list opens on.
  static const InvoicePeriod period = InvoicePeriod.thisMonth;

  /// Pause after the last keystroke before the invoices search runs.
  static const Duration searchDebounce = Duration(milliseconds: 350);
}
