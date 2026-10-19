import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_remote_data_source.dart';
import 'package:sijilak/features/invoices/data/models/invoice_draft_model.dart';
import 'package:sijilak/features/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_draft.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_period.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_summary.dart';
import 'package:sijilak/features/invoices/domain/entities/new_payment.dart';
import 'package:sijilak/features/invoices/domain/entities/payment_method.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_draft_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoices_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/issue_invoice_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/record_payment_use_case.dart';

/// Use cases over the real repository and data source, served by the mock
/// backend with the bundled fixtures.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final today = DateTime(2026, 10, 18, 14);
  late InvoicesRepositoryImpl repository;
  late GetInvoicesUseCase getInvoices;
  late GetInvoiceUseCase getInvoice;
  late GetInvoiceDraftUseCase getDraft;
  late IssueInvoiceUseCase issueInvoice;
  late RecordPaymentUseCase recordPayment;

  setUp(() {
    final client = MockApiClient(
      modules: [InvoicesMockApi(MockAssets(), clock: () => today)],
    );
    repository = InvoicesRepositoryImpl(InvoicesRemoteDataSourceImpl(client));
    getInvoices = GetInvoicesUseCase(repository);
    getInvoice = GetInvoiceUseCase(repository);
    getDraft = GetInvoiceDraftUseCase(repository);
    issueInvoice = IssueInvoiceUseCase(repository);
    recordPayment = RecordPaymentUseCase(repository);
  });

  NewPayment payment(int amount) => NewPayment(
    amount: amount,
    method: PaymentMethod.card,
    date: DateTime(2026, 10, 18),
    reference: 'REF-1',
    hasReceipt: true,
  );

  test('lists every invoice with the overview', () async {
    final listing = (await getInvoices(
      const GetInvoicesParams(period: InvoicePeriod.thisMonth),
    )).dataOrNull!;
    expect(listing.invoices.map((i) => i.number), [392, 391, 388, 387, 385]);
    expect(listing.overview.total, 128450 + 21550 + 12650);
    expect(listing.invoices.first.amount, 38000);
  });

  test('filters by status and by search text', () async {
    final late = (await getInvoices(
      const GetInvoicesParams(
        status: InvoiceStatus.late,
        period: InvoicePeriod.thisMonth,
      ),
    )).dataOrNull!;
    expect(late.invoices.map((i) => i.number), [388]);
    final search = (await getInvoices(const GetInvoicesParams(query: '385')))
        .dataOrNull!;
    expect(search.invoices.map((i) => i.number), [385]);
  });

  test(
    'loads a detail with lines and payments, or fails with not found',
    () async {
      final invoice = (await getInvoice(391)).dataOrNull!;
      expect(invoice.status, InvoiceStatus.due);
      expect(invoice.lines.length, 2);
      expect(invoice.totals.total.round(), 14375);
      expect(invoice.payments, isEmpty);
      final missing = await getInvoice(999);
      expect(missing.failureOrNull, isA<NotFoundFailure>());
    },
  );

  test('the draft carries lines only, with today as issue date', () async {
    final draft = (await getDraft(const GetInvoiceDraftParams())).dataOrNull!;
    expect(draft.issueDate, DateTime(2026, 10, 18));
    expect(draft.paymentTermsDays, 15);
    expect(draft.lines, isNotEmpty);
    expect(InvoiceDraftModel.toJson(draft).keys, isNot(contains('total')));
  });

  test('issuing adds the invoice to the list and the due overview', () async {
    final draft = (await getDraft(const GetInvoiceDraftParams())).dataOrNull!;
    final issued = (await issueInvoice(draft)).dataOrNull!;
    expect(issued.number, 393);
    expect(issued.status, InvoiceStatus.due);
    expect(issued.dueDate, DateTime(2026, 11, 2));

    final listing = (await getInvoices(
      const GetInvoicesParams(period: InvoicePeriod.thisMonth),
    )).dataOrNull!;
    expect(listing.invoices.first.number, 393);
    expect(listing.invoices.first.amount, 14375);
    expect(listing.overview.due, 21550 + 14375);
  });

  test(
    'issuing drops zero-quantity lines and rejects an empty draft',
    () async {
      final draft = (await getDraft(const GetInvoiceDraftParams())).dataOrNull!;
      final zeroed = draft.withLines([
        draft.lines.first.withQuantity(0),
        draft.lines.last,
      ]);
      final issued = (await issueInvoice(zeroed)).dataOrNull!;
      expect(issued.lines, [draft.lines.last]);

      final empty = InvoiceDraft(
        customer: draft.customer,
        vatNumber: draft.vatNumber,
        issueDate: draft.issueDate,
        paymentTermsDays: draft.paymentTermsDays,
        lines: [const DocumentLine(name: 'x', unitPrice: 1, quantity: 0)],
      );
      expect(
        (await issueInvoice(empty)).failureOrNull,
        isA<ValidationFailure>(),
      );
    },
  );

  test('recording the full amount marks the invoice paid everywhere', () async {
    final result = await recordPayment(
      RecordPaymentParams(invoiceNumber: 391, payment: payment(14375)),
    );
    final paid = result.dataOrNull!;
    expect(paid.isPaid, isTrue);
    expect(paid.latestPayment?.amount, 14375);
    expect(paid.latestPayment?.method, PaymentMethod.card);
    expect(paid.latestPayment?.reference, 'REF-1');
    expect(paid.latestPayment?.hasReceipt, isTrue);
    expect(paid.balance, 0);

    expect((await getInvoice(391)).dataOrNull!.isPaid, isTrue);
    final listing = (await getInvoices(
      const GetInvoicesParams(period: InvoicePeriod.thisMonth),
    )).dataOrNull!;
    expect(
      listing.invoices.firstWhere((i) => i.number == 391).status,
      InvoiceStatus.paid,
    );
    expect(listing.overview.paid, 128450 + 14375);
    expect(listing.overview.due, 21550 - 14375);
  });

  test('a partial payment keeps the invoice open', () async {
    final partial = (await recordPayment(
      RecordPaymentParams(invoiceNumber: 391, payment: payment(5000)),
    )).dataOrNull!;
    expect(partial.isPaid, isFalse);
    expect(partial.balance, 9375);
  });

  test('rejects zero, excessive and repeated payments', () async {
    Future<Failure?> failureOf(int amount, [int number = 391]) async =>
        (await recordPayment(
          RecordPaymentParams(invoiceNumber: number, payment: payment(amount)),
        )).failureOrNull;

    expect(await failureOf(0), isA<ValidationFailure>());
    final tooMuch = await failureOf(99999) as ValidationFailure;
    expect(tooMuch.fields['amount'], 'exceeds_balance');
    expect(await failureOf(1, 999), isA<NotFoundFailure>());
    final already = await failureOf(1, 392) as ValidationFailure;
    expect(already.fields['invoice'], 'already_paid');
  });
}
