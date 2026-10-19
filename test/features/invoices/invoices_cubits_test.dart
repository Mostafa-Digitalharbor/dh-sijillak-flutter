import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_detail.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_draft.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_listing.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_period.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_summary.dart';
import 'package:sijilak/features/invoices/domain/entities/product.dart';
import 'package:sijilak/features/invoices/domain/entities/invoices_overview.dart';
import 'package:sijilak/features/invoices/domain/entities/new_payment.dart';
import 'package:sijilak/features/invoices/domain/entities/payment.dart';
import 'package:sijilak/features/invoices/domain/entities/payment_method.dart';
import 'package:sijilak/features/invoices/domain/repositories/invoices_repository.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_draft_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoices_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/issue_invoice_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/record_payment_use_case.dart';
import 'package:sijilak/features/invoices/presentation/cubit/invoice_cubit.dart';
import 'package:sijilak/features/invoices/presentation/cubit/invoices_cubit.dart';
import 'package:sijilak/features/invoices/presentation/cubit/new_invoice_cubit.dart';
import 'package:sijilak/features/invoices/presentation/cubit/payment_cubit.dart';
import 'package:sijilak/features/invoices/presentation/cubit/payment_done_cubit.dart';

const _line = DocumentLine(name: 'item', unitPrice: 1000);

final _draft = InvoiceDraft(
  customer: 'c',
  vatNumber: 'v',
  issueDate: DateTime(2026, 10, 18),
  paymentTermsDays: 15,
  lines: const [
    _line,
    DocumentLine(name: 'other', unitPrice: 500),
  ],
);

InvoiceDetail _invoice({List<Payment> payments = const []}) => InvoiceDetail(
  number: 7,
  customer: 'c',
  vatNumber: 'v',
  issueDate: DateTime(2026, 10, 1),
  dueDate: DateTime(2026, 10, 16),
  lines: const [_line],
  status: payments.isEmpty ? InvoiceStatus.due : InvoiceStatus.paid,
  payments: payments,
);

/// Hand-written repository whose every call returns [failure] when set.
class _FakeRepository implements InvoicesRepository {
  _FakeRepository({this.failure, InvoiceDetail? invoice})
    : invoice = invoice ?? _invoice();

  final Failure? failure;
  final InvoiceDetail invoice;
  NewPayment? lastPayment;
  InvoiceDraft? lastIssued;
  InvoiceStatus? lastStatus;
  int? lastQuoteNumber;

  Result<T> _result<T>(T data) =>
      failure == null ? Success(data) : Failed(failure!);

  @override
  Future<Result<InvoiceListing>> getInvoices({
    InvoiceStatus? status,
    String query = '',
    InvoicePeriod period = InvoicePeriod.allTime,
  }) async {
    lastStatus = status;
    return _result(
      const InvoiceListing(
        overview: InvoicesOverview(paid: 1, due: 2, late: 3),
        invoices: [],
      ),
    );
  }

  @override
  Future<Result<InvoiceDetail>> getInvoice(int number) async =>
      _result(invoice);

  @override
  Future<Result<InvoiceDraft>> getDraft({int? quoteNumber}) async {
    lastQuoteNumber = quoteNumber;
    return _result(_draft);
  }

  @override
  Future<Result<List<Product>>> getProducts() async =>
      _result(const [Product(id: 'p', name: 'P', unitPrice: 5)]);

  @override
  Future<Result<InvoiceDetail>> issueInvoice(InvoiceDraft draft) async {
    lastIssued = draft;
    return _result(invoice);
  }

  @override
  Future<Result<InvoiceDetail>> recordPayment(
    int number,
    NewPayment payment,
  ) async {
    lastPayment = payment;
    return _result(
      InvoiceDetail(
        number: number,
        customer: 'c',
        vatNumber: 'v',
        issueDate: DateTime(2026, 10, 1),
        dueDate: DateTime(2026, 10, 16),
        lines: const [_line],
        status: InvoiceStatus.paid,
        payments: [
          Payment(
            amount: payment.amount,
            method: payment.method,
            date: payment.date,
          ),
        ],
      ),
    );
  }
}

void main() {
  const failure = NetworkFailure();

  group('InvoicesCubit', () {
    test('loads, then reloads with the selected tab filter', () async {
      final repo = _FakeRepository();
      final cubit = InvoicesCubit(GetInvoicesUseCase(repo));
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.listing?.overview.total, 6);

      cubit.selectTab(2);
      expect(cubit.state.filter, InvoiceStatus.due);
      await Future<void>.delayed(Duration.zero);
      expect(repo.lastStatus, InvoiceStatus.due);
      expect(cubit.state.status, ViewStatus.success);
    });

    test('reports a failure', () async {
      final cubit = InvoicesCubit(
        GetInvoicesUseCase(_FakeRepository(failure: failure)),
      );
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, failure);
    });
  });

  group('InvoiceCubit', () {
    test('loads an invoice and reloads it', () async {
      final cubit = InvoiceCubit(GetInvoiceUseCase(_FakeRepository()));
      addTearDown(cubit.close);
      await cubit.load(7);
      expect(cubit.state.invoice?.number, 7);
      await cubit.reload();
      expect(cubit.state.status, ViewStatus.success);
    });

    test('reports a failure', () async {
      final cubit = InvoiceCubit(
        GetInvoiceUseCase(_FakeRepository(failure: failure)),
      );
      addTearDown(cubit.close);
      await cubit.load(7);
      expect(cubit.state.status, ViewStatus.failure);
    });
  });

  group('PaymentDoneCubit', () {
    test('shows the latest recorded payment', () async {
      final paid = _invoice(
        payments: [
          Payment(
            amount: 1150,
            method: PaymentMethod.cash,
            date: DateTime(2026, 10, 18),
          ),
        ],
      );
      final cubit = PaymentDoneCubit(
        GetInvoiceUseCase(_FakeRepository(invoice: paid)),
      );
      addTearDown(cubit.close);
      await cubit.load(7);
      expect(cubit.state.payment?.amount, 1150);
      expect(cubit.state.payment?.method, PaymentMethod.cash);
    });

    test('fails with not found when nothing was paid', () async {
      final cubit = PaymentDoneCubit(GetInvoiceUseCase(_FakeRepository()));
      addTearDown(cubit.close);
      await cubit.load(7);
      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, isA<NotFoundFailure>());
    });
  });

  group('NewInvoiceCubit', () {
    NewInvoiceCubit build(_FakeRepository repo) => NewInvoiceCubit(
      GetInvoiceDraftUseCase(repo),
      IssueInvoiceUseCase(repo),
    );

    test('edits quantities and lines in its own state', () async {
      final cubit = build(_FakeRepository());
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.draft?.lines.length, 2);

      cubit.changeQuantity(0, 2);
      expect(cubit.state.draft?.lines.first.quantity, 3);
      cubit.changeQuantity(0, -10);
      expect(cubit.state.draft?.lines.first.quantity, 0);
      cubit.changeQuantity(0, 100000);
      expect(
        cubit.state.draft?.lines.first.quantity,
        NewInvoiceCubit.maxQuantity,
      );

      cubit.addLine(const DocumentLine(name: 'new', unitPrice: 5));
      expect(cubit.state.draft?.lines.length, 3);
      cubit.removeLine(0);
      expect(cubit.state.draft?.lines.map((l) => l.name), ['other', 'new']);
    });

    test('starts from a quote and keeps it when retrying', () async {
      final repo = _FakeRepository();
      final cubit = build(repo);
      addTearDown(cubit.close);
      await cubit.load(quoteNumber: 142);
      expect(repo.lastQuoteNumber, 142);
      repo.lastQuoteNumber = null;
      await cubit.reload();
      expect(repo.lastQuoteNumber, 142);

      await cubit.load();
      expect(repo.lastQuoteNumber, isNull);
    });

    test('a removed line leaves the totals of the others', () async {
      final cubit = build(_FakeRepository());
      addTearDown(cubit.close);
      await cubit.load();
      cubit.addLine(const DocumentLine(name: 'custom', unitPrice: 300));
      expect(cubit.state.draft?.totals.subtotal, 1800);
      cubit.removeLine(0);
      expect(cubit.state.draft?.totals.subtotal, 800);
    });

    test('issuing sends the edited lines and exposes the invoice', () async {
      final repo = _FakeRepository();
      final cubit = build(repo);
      addTearDown(cubit.close);
      await cubit.load();
      cubit.changeQuantity(1, -1);
      await cubit.issue();
      expect(cubit.state.submitStatus, ViewStatus.success);
      expect(cubit.state.issued?.number, 7);
      expect(repo.lastIssued?.lines.length, 1);
    });

    test('reports load and issue failures', () async {
      final bad = build(_FakeRepository(failure: failure));
      addTearDown(bad.close);
      await bad.load();
      expect(bad.state.status, ViewStatus.failure);

      final empty = build(_FakeRepository());
      addTearDown(empty.close);
      await empty.load();
      empty
        ..changeQuantity(0, -1)
        ..changeQuantity(1, -1);
      await empty.issue();
      expect(empty.state.submitStatus, ViewStatus.failure);
      expect(empty.state.submitFailure, isA<ValidationFailure>());
    });
  });

  group('PaymentCubit', () {
    PaymentCubit build(_FakeRepository repo) => PaymentCubit(
      RecordPaymentUseCase(repo),
      invoice: _invoice(),
      clock: () => DateTime(2026, 10, 18, 15, 30),
    );

    test('starts today with bank transfer and tracks the form', () {
      final cubit = build(_FakeRepository());
      addTearDown(cubit.close);
      expect(cubit.state.date, DateTime(2026, 10, 18));
      expect(cubit.state.method, PaymentMethod.bankTransfer);
      cubit
        ..select(PaymentMethod.card)
        ..pickDate(DateTime(2026, 10, 10))
        ..toggleReceipt();
      expect(cubit.state.method, PaymentMethod.card);
      expect(cubit.state.date, DateTime(2026, 10, 10));
      expect(cubit.state.hasReceipt, isTrue);
    });

    test('submits the real field values', () async {
      final repo = _FakeRepository();
      final cubit = build(repo);
      addTearDown(cubit.close);
      cubit
        ..select(PaymentMethod.cash)
        ..toggleReceipt();
      await cubit.submit(amountText: '١٬١٥٠', reference: ' V-9 ');
      expect(repo.lastPayment?.amount, 1150);
      expect(repo.lastPayment?.method, PaymentMethod.cash);
      expect(repo.lastPayment?.reference, 'V-9');
      expect(repo.lastPayment?.hasReceipt, isTrue);
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.recorded?.isPaid, isTrue);
    });

    test('rejects an empty amount and reports server failures', () async {
      final repo = _FakeRepository();
      final cubit = build(repo);
      addTearDown(cubit.close);
      await cubit.submit(amountText: '', reference: '');
      expect(cubit.state.failure, isA<ValidationFailure>());
      expect(repo.lastPayment, isNull);

      final failing = build(_FakeRepository(failure: failure));
      addTearDown(failing.close);
      await failing.submit(amountText: '10', reference: '');
      expect(failing.state.status, ViewStatus.failure);
      expect(failing.state.failure, failure);
    });
  });
}
