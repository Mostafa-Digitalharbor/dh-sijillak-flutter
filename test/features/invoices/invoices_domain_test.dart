import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/constants/app_config.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/invoices/domain/entities/document_totals.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_detail.dart';
import 'package:sijilak/features/invoices/domain/entities/invoices_overview.dart';
import 'package:sijilak/features/invoices/domain/entities/payment.dart';
import 'package:sijilak/features/invoices/domain/entities/payment_method.dart';
import 'package:sijilak/features/invoices/presentation/utils/amount_input.dart';

void main() {
  const lines = [
    DocumentLine(name: 'a', unitPrice: 10000),
    DocumentLine(name: 'b', unitPrice: 2500, quantity: 2),
  ];

  group('DocumentTotals', () {
    test('computes subtotal, VAT and total from lines only', () {
      final totals = DocumentTotals.of(lines);
      expect(totals.subtotal, 15000);
      expect(totals.vat, 15000 * AppConfig.vatRate);
      expect(totals.total, 15000 + 15000 * AppConfig.vatRate);
    });

    test('is empty for no lines', () {
      expect(DocumentTotals.of(const []).total, 0);
    });
  });

  group('InvoiceDetail', () {
    InvoiceDetail invoice({List<Payment> payments = const []}) => InvoiceDetail(
      number: 1,
      customer: 'c',
      vatNumber: 'v',
      issueDate: DateTime(2026, 10, 1),
      dueDate: DateTime(2026, 10, 11),
      lines: const [DocumentLine(name: 'a', unitPrice: 1000)],
      payments: payments,
    );

    test('balance is the rounded total minus payments, never negative', () {
      expect(invoice().balance, 1150);
      final partial = invoice(
        payments: [
          Payment(
            amount: 150,
            method: PaymentMethod.cash,
            date: DateTime(2026, 10, 2),
          ),
        ],
      );
      expect(partial.balance, 1000);
      expect(partial.latestPayment?.amount, 150);
      final over = invoice(
        payments: [
          Payment(
            amount: 5000,
            method: PaymentMethod.cash,
            date: DateTime(2026, 10, 2),
          ),
        ],
      );
      expect(over.balance, 0);
    });

    test('counts whole days until due and stops at zero', () {
      final i = invoice();
      expect(i.daysUntilDue(DateTime(2026, 10, 1, 23)), 10);
      expect(i.daysUntilDue(DateTime(2026, 11, 1)), 0);
    });
  });

  group('InvoicesOverview', () {
    test('shares are whole percentages and safe when empty', () {
      const overview = InvoicesOverview(paid: 50, due: 30, late: 20);
      expect(overview.total, 100);
      expect(overview.percent(overview.paid), 50);
      expect(const InvoicesOverview(paid: 0, due: 0, late: 0).percent(0), 0);
    });
  });

  group('AmountInput', () {
    test('parses Latin, grouped and Arabic-Indic amounts', () {
      expect(AmountInput.parse('14,375'), 14375);
      expect(AmountInput.parse('١٤٬٣٧٥'), 14375);
      expect(AmountInput.parse('12.6'), 13);
      expect(AmountInput.parse(''), 0);
      expect(AmountInput.parse('abc'), 0);
    });
  });
}
