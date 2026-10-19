import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_remote_data_source.dart';
import 'package:sijilak/features/invoices/data/models/product_model.dart';
import 'package:sijilak/features/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_listing.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_period.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_summary.dart';
import 'package:sijilak/features/invoices/domain/entities/invoices_overview.dart';
import 'package:sijilak/features/invoices/domain/repositories/invoices_repository.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_draft_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoices_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_products_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/issue_invoice_use_case.dart';
import 'package:sijilak/features/invoices/presentation/cubit/invoices_cubit.dart';
import 'package:sijilak/features/invoices/presentation/cubit/product_catalog_cubit.dart';

/// Records the filter every list request used.
class _RecordingGetInvoices extends GetInvoicesUseCase {
  _RecordingGetInvoices(this.failure) : super(_NoRepository());

  final Failure? failure;
  final calls = <GetInvoicesParams>[];

  @override
  Future<Result<InvoiceListing>> call(GetInvoicesParams params) async {
    calls.add(params);
    if (failure != null) return Failed(failure!);
    return const Success(
      InvoiceListing(
        overview: InvoicesOverview(paid: 1, due: 1, late: 1),
        invoices: [],
      ),
    );
  }
}

class _NoRepository implements InvoicesRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('invoice periods over the mock backend', () {
    final today = DateTime(2026, 10, 18, 14);
    late InvoicesRepositoryImpl repository;
    late GetInvoicesUseCase getInvoices;

    setUp(() {
      final client = MockApiClient(
        modules: [InvoicesMockApi(MockAssets(), clock: () => today)],
      );
      repository = InvoicesRepositoryImpl(InvoicesRemoteDataSourceImpl(client));
      getInvoices = GetInvoicesUseCase(repository);
    });

    Future<InvoiceListing> list(
      InvoicePeriod period, {
      InvoiceStatus? status,
      String query = '',
    }) async => (await getInvoices(
      GetInvoicesParams(status: status, query: query, period: period),
    )).dataOrNull!;

    test('this month keeps the invoices issued this month', () async {
      final listing = await list(InvoicePeriod.thisMonth);
      expect(listing.invoices.map((i) => i.number), [392, 391, 388, 387, 385]);
      expect(listing.overview.total, 128450 + 21550 + 12650);
      expect(
        listing.invoices.every(
          (i) => i.date.year == 2026 && i.date.month == 10,
        ),
        isTrue,
      );
    });

    test('last month, this year and all time widen the window', () async {
      final last = await list(InvoicePeriod.lastMonth);
      expect(last.invoices.map((i) => i.number), [384, 383]);
      expect(last.invoices.every((i) => i.date.month == 9), isTrue);
      expect(last.overview.paid, 96200);

      final year = await list(InvoicePeriod.thisYear);
      expect(year.invoices.map((i) => i.number), [
        392,
        391,
        388,
        387,
        385,
        384,
        383,
        380,
      ]);

      final all = await list(InvoicePeriod.allTime);
      expect(all.invoices.length, 9);
      expect(all.invoices.last.date.year, 2025);
      expect(all.overview.paid, 1264800);
    });

    test('the period combines with the status and the search text', () async {
      final paidLastMonth = await list(
        InvoicePeriod.lastMonth,
        status: InvoiceStatus.paid,
      );
      expect(paidLastMonth.invoices.length, 2);
      expect(
        (await list(InvoicePeriod.thisMonth, query: '384')).invoices,
        isEmpty,
      );
      expect(
        (await list(
          InvoicePeriod.allTime,
          query: '384',
        )).invoices.single.number,
        384,
      );
    });

    test(
      'a newly issued invoice counts in the periods that contain today',
      () async {
        final draft = (await GetInvoiceDraftUseCase(repository)(
          const GetInvoiceDraftParams(),
        )).dataOrNull!;
        final lastBefore = (await list(InvoicePeriod.lastMonth)).overview;
        final monthBefore = (await list(InvoicePeriod.thisMonth)).overview;
        final issued = (await IssueInvoiceUseCase(repository)(draft))
            .dataOrNull!;
        final amount = issued.totals.total.round();

        expect(
          (await list(InvoicePeriod.thisMonth)).overview.due,
          monthBefore.due + amount,
        );
        expect((await list(InvoicePeriod.lastMonth)).overview, lastBefore);
        expect(
          (await list(InvoicePeriod.thisMonth)).invoices.first.number,
          issued.number,
        );
      },
    );
  });

  group('product catalog', () {
    late InvoicesRepositoryImpl repository;

    setUp(() {
      final client = MockApiClient(
        modules: [InvoicesMockApi(MockAssets(), clock: DateTime.now)],
      );
      repository = InvoicesRepositoryImpl(InvoicesRemoteDataSourceImpl(client));
    });

    test('GetProductsUseCase serves the catalog fixture', () async {
      final products = (await GetProductsUseCase(repository)(const NoParams()))
          .dataOrNull!;
      expect(products, isNotEmpty);
      expect(
        products.every((p) => p.unitPrice > 0 && p.name.isNotEmpty),
        isTrue,
      );
      expect(products.map((p) => p.id).toSet().length, products.length);
    });

    test('a product becomes a one-unit invoice line', () {
      final product = ProductModel.fromJson(const {
        'id': 'p',
        'name': 'Item',
        'unitPrice': 250,
      });
      expect(
        product.toLine(),
        const DocumentLine(name: 'Item', unitPrice: 250),
      );
      expect(product.toLine(quantity: 3).total, 750);
    });

    test(
      'ProductCatalogCubit loads the catalog or reports a failure',
      () async {
        final ok = ProductCatalogCubit(GetProductsUseCase(repository));
        addTearDown(ok.close);
        await ok.load();
        expect(ok.state.status, ViewStatus.success);
        expect(ok.state.products, isNotEmpty);

        final broken = ProductCatalogCubit(
          GetProductsUseCase(
            InvoicesRepositoryImpl(
              InvoicesRemoteDataSourceImpl(MockApiClient(modules: const [])),
            ),
          ),
        );
        addTearDown(broken.close);
        await broken.load();
        expect(broken.state.status, ViewStatus.failure);
        expect(broken.state.failure, isNotNull);
      },
    );
  });

  group('InvoicesCubit search and period', () {
    const debounce = Duration(milliseconds: 100);

    test('typing is debounced into a single request', () async {
      final recorder = _RecordingGetInvoices(null);
      final cubit = InvoicesCubit(recorder, searchDebounce: debounce);
      addTearDown(cubit.close);
      await cubit.load();
      recorder.calls.clear();

      cubit
        ..search('3')
        ..search('39');
      await Future<void>.delayed(const Duration(milliseconds: 40));
      cubit.search('392');
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(recorder.calls, isEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(recorder.calls.map((p) => p.query), ['392']);
      expect(cubit.state.query, '392');
    });

    test('closing the search field clears the filter and reloads', () async {
      final recorder = _RecordingGetInvoices(null);
      final cubit = InvoicesCubit(recorder, searchDebounce: debounce);
      addTearDown(cubit.close);
      await cubit.load();

      cubit.toggleSearch();
      expect(cubit.state.searching, isTrue);
      cubit.search('abc');
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(recorder.calls.last.query, 'abc');

      cubit.toggleSearch();
      expect(cubit.state.searching, isFalse);
      expect(cubit.state.query, '');
      await Future<void>.delayed(Duration.zero);
      expect(recorder.calls.last.query, '');
    });

    test(
      'closing before the debounce fires cancels the pending search',
      () async {
        final recorder = _RecordingGetInvoices(null);
        final cubit = InvoicesCubit(recorder, searchDebounce: debounce);
        addTearDown(cubit.close);
        await cubit.load();
        recorder.calls.clear();
        cubit
          ..toggleSearch()
          ..search('x')
          ..toggleSearch();
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(recorder.calls.map((p) => p.query), ['']);
      },
    );

    test('the period starts on this month and reloads when changed', () async {
      final recorder = _RecordingGetInvoices(null);
      final cubit = InvoicesCubit(recorder, searchDebounce: debounce);
      addTearDown(cubit.close);
      expect(cubit.state.period, InvoicePeriod.thisMonth);
      await cubit.load();
      expect(recorder.calls.last.period, InvoicePeriod.thisMonth);

      cubit.selectPeriod(InvoicePeriod.lastMonth);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.period, InvoicePeriod.lastMonth);
      expect(recorder.calls.last.period, InvoicePeriod.lastMonth);

      final count = recorder.calls.length;
      cubit.selectPeriod(InvoicePeriod.lastMonth);
      await Future<void>.delayed(Duration.zero);
      expect(recorder.calls.length, count);
    });
  });
}
