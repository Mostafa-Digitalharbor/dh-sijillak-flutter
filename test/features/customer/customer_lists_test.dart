import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/customer/data/datasources/customer_mock_api.dart';
import 'package:sijilak/features/customer/data/datasources/customer_remote_data_source.dart';
import 'package:sijilak/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:sijilak/features/customer/domain/entities/customer.dart';
import 'package:sijilak/features/customer/domain/entities/customer_deal.dart';
import 'package:sijilak/features/customer/domain/entities/customer_invoice.dart';
import 'package:sijilak/features/customer/domain/entities/customer_summary.dart';
import 'package:sijilak/features/customer/domain/repositories/customer_repository.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_deals_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_invoices_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customers_use_case.dart';
import 'package:sijilak/features/customer/presentation/cubit/customer_cubit.dart';
import 'package:sijilak/features/customer/presentation/cubit/customers_cubit.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_remote_data_source.dart';
import 'package:sijilak/features/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_draft.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_summary.dart';
import 'package:sijilak/features/invoices/domain/usecases/issue_invoice_use_case.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_mock_api.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_remote_data_source.dart';
import 'package:sijilak/features/pipeline/data/repositories/pipeline_repository_impl.dart';
import 'package:sijilak/features/pipeline/domain/entities/deal_stage.dart';
import 'package:sijilak/features/pipeline/domain/entities/new_deal.dart';
import 'package:sijilak/features/pipeline/domain/usecases/create_deal_use_case.dart';

const _modernFoods = 'c-modern-foods';
const _noor = 'c-noor-trading';
const _fastFood = 'c-fast-food';

class _FailingRepository implements CustomerRepository {
  int customerCalls = 0;
  int dealCalls = 0;
  int invoiceCalls = 0;

  @override
  Future<Result<List<CustomerSummary>>> getCustomers(String query) async =>
      const Failed(NetworkFailure());

  @override
  Future<Result<Customer>> getCustomer(String id) async {
    customerCalls++;
    return const Failed(NetworkFailure());
  }

  @override
  Future<Result<List<CustomerDeal>>> getDeals(String id) async {
    dealCalls++;
    return const Failed(NetworkFailure());
  }

  @override
  Future<Result<List<CustomerInvoice>>> getInvoices(String id) async {
    invoiceCalls++;
    return const Failed(NetworkFailure());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 18, 15);
  late CustomerRepositoryImpl repository;
  late GetCustomersUseCase getCustomers;
  late GetCustomerUseCase getCustomer;
  late GetCustomerDealsUseCase getDeals;
  late GetCustomerInvoicesUseCase getInvoices;
  late CreateDealUseCase createDeal;
  late IssueInvoiceUseCase issueInvoice;

  setUp(() {
    final assets = MockAssets();
    final client = MockApiClient(
      modules: [
        CustomerMockApi(assets, clock: () => now),
        PipelineMockApi(assets, clock: () => now),
        InvoicesMockApi(assets, clock: () => now),
      ],
    );
    repository = CustomerRepositoryImpl(CustomerRemoteDataSourceImpl(client));
    getCustomers = GetCustomersUseCase(repository);
    getCustomer = GetCustomerUseCase(repository);
    getDeals = GetCustomerDealsUseCase(repository);
    getInvoices = GetCustomerInvoicesUseCase(repository);
    createDeal = CreateDealUseCase(
      PipelineRepositoryImpl(PipelineRemoteDataSourceImpl(client)),
    );
    issueInvoice = IssueInvoiceUseCase(
      InvoicesRepositoryImpl(InvoicesRemoteDataSourceImpl(client)),
    );
  });

  group('GetCustomersUseCase', () {
    test('lists every customer without a query', () async {
      final customers = (await getCustomers('')).dataOrNull!;

      expect(customers, hasLength(6));
      expect(customers.first.id, _modernFoods);
      expect(customers.first.amountDue, 12650);
    });

    test('filters by name', () async {
      final customers = (await getCustomers('الأغذية')).dataOrNull!;

      expect(customers.map((c) => c.id), [_modernFoods]);
    });

    test('filters by city', () async {
      final customers = (await getCustomers('جدة')).dataOrNull!;

      expect(customers.map((c) => c.id), [
        'c-united-supplies',
        'c-golden-realty',
      ]);
    });

    test(
      'ignores surrounding blanks and returns nothing for no match',
      () async {
        expect((await getCustomers('  الأغذية ')).dataOrNull, hasLength(1));
        expect((await getCustomers('zzz')).dataOrNull, isEmpty);
      },
    );
  });

  group('GetCustomerUseCase', () {
    test('every listed customer opens with its details', () async {
      for (final summary in (await getCustomers('')).dataOrNull!) {
        final customer = (await getCustomer(summary.id)).dataOrNull!;

        expect(customer.name, summary.name);
        expect(customer.location, summary.location);
        expect(customer.phone, isNotEmpty);
        expect(customer.activity, isNotEmpty);
      }
    });

    test('the featured customer keeps its profile', () async {
      final customer = (await getCustomer(_modernFoods)).dataOrNull!;

      expect(customer.location, 'الرياض · قطاع الصناعة');
      expect(customer.totalSales, 215000);
      expect(customer.openDeals, 2);
    });
  });

  group('customer deals', () {
    test('returns only the deals of that customer', () async {
      final deals = (await getDeals(_modernFoods)).dataOrNull!;

      expect(deals.map((d) => d.id), ['d-4', 'd-8']);
      expect(deals.first.stage, DealStage.quote);
      expect(deals.first.value, 65000);
      expect(deals.first.probability, 60);
    });

    test(
      'a deal created through the pipeline appears under its customer',
      () async {
        await createDeal(
          const NewDeal(
            title: 'Brand new deal',
            customerId: _fastFood,
            ownerId: 'u-1',
            value: 12000,
            stage: DealStage.qualified,
          ),
        );

        final deals = (await getDeals(_fastFood)).dataOrNull!;
        expect(deals, hasLength(2));
        expect(deals.first.title, 'Brand new deal');
        expect(deals.first.stage, DealStage.qualified);
        expect(
          (await getDeals(_modernFoods)).dataOrNull!.map((d) => d.title),
          isNot(contains('Brand new deal')),
        );
      },
    );

    test('a customer without deals gets an empty list', () async {
      expect((await getDeals(_noor)).dataOrNull, isEmpty);
    });

    test('an unknown customer is a not-found failure', () async {
      expect((await getDeals('nope')).failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('customer invoices', () {
    test('returns the invoices issued to that customer', () async {
      final invoices = (await getInvoices(_modernFoods)).dataOrNull!;

      expect(invoices.map((i) => i.number), [392, 388, 384]);
      expect(invoices[1].status, InvoiceStatus.late);
      expect(invoices[1].amount, 12650);
    });

    test('an invoice issued for the customer appears first', () async {
      final modern = (await getCustomer(_modernFoods)).dataOrNull!;
      final issued = await issueInvoice(
        InvoiceDraft(
          customer: modern.name,
          vatNumber: modern.vatNumber,
          issueDate: DateTime(2026, 10, 18),
          paymentTermsDays: 30,
          lines: const [DocumentLine(name: 'Service', unitPrice: 1000)],
        ),
      );
      final number = issued.dataOrNull!.number;

      final invoices = (await getInvoices(_modernFoods)).dataOrNull!;
      expect(invoices.first.number, number);
      expect(invoices.first.status, InvoiceStatus.due);
      expect(invoices.first.amount, 1150);
      expect(
        (await getInvoices('c-united-supplies')).dataOrNull!
            .map((i) => i.number),
        isNot(contains(number)),
      );
    });

    test('a customer without invoices gets an empty list', () async {
      expect((await getInvoices(_noor)).dataOrNull, isEmpty);
    });

    test('an unknown customer is a not-found failure', () async {
      expect((await getInvoices('nope')).failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('CustomersCubit', () {
    test('loads the list', () async {
      final cubit = CustomersCubit(getCustomers);
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.customers, hasLength(6));
    });

    test('searching waits for the debounce and filters', () async {
      final cubit = CustomersCubit(
        getCustomers,
        searchDebounce: const Duration(milliseconds: 10),
      );
      addTearDown(cubit.close);
      await cubit.load();

      cubit.toggleSearch();
      cubit.search('اللوجستية');
      expect(cubit.state.customers, hasLength(6));
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(cubit.state.searching, isTrue);
      expect(cubit.state.customers.map((c) => c.id), ['c-logistics']);
    });

    test('closing the search clears the query and restores the list', () async {
      final cubit = CustomersCubit(
        getCustomers,
        searchDebounce: const Duration(milliseconds: 10),
      );
      addTearDown(cubit.close);
      await cubit.load();
      cubit
        ..toggleSearch()
        ..search('اللوجستية');
      await Future<void>.delayed(const Duration(milliseconds: 60));

      cubit.toggleSearch();
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(cubit.state.query, '');
      expect(cubit.state.searching, isFalse);
      expect(cubit.state.customers, hasLength(6));
    });

    test('reports a failure', () async {
      final cubit = CustomersCubit(GetCustomersUseCase(_FailingRepository()));
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
    });
  });

  group('CustomerCubit tabs', () {
    CustomerCubit cubit() => CustomerCubit(getCustomer, getDeals, getInvoices);

    test('deals and invoices load lazily when their tab opens', () async {
      final c = cubit();
      addTearDown(c.close);
      await c.load(_modernFoods);

      expect(c.state.deals.status, ViewStatus.initial);
      expect(c.state.invoices.status, ViewStatus.initial);

      c.selectTab(2);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(c.state.deals.status, ViewStatus.success);
      expect(c.state.deals.items, hasLength(2));
      expect(c.state.invoices.status, ViewStatus.initial);

      c.selectTab(1);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(c.state.invoices.status, ViewStatus.success);
      expect(c.state.invoices.items, hasLength(3));
    });

    test('a tab is not reloaded when reopened', () async {
      final repository = _FailingRepository();
      final c = CustomerCubit(
        GetCustomerUseCase(repository),
        GetCustomerDealsUseCase(repository),
        GetCustomerInvoicesUseCase(repository),
      );
      addTearDown(c.close);
      await c.load('c-1');

      c.selectTab(2);
      await Future<void>.delayed(Duration.zero);
      c.selectTab(0);
      c.selectTab(2);
      await Future<void>.delayed(Duration.zero);

      expect(repository.dealCalls, 1);
      expect(c.state.deals.status, ViewStatus.failure);
      expect(c.state.deals.failure, const NetworkFailure());
    });

    test('retrying a failed tab loads it again', () async {
      final repository = _FailingRepository();
      final c = CustomerCubit(
        GetCustomerUseCase(repository),
        GetCustomerDealsUseCase(repository),
        GetCustomerInvoicesUseCase(repository),
      );
      addTearDown(c.close);
      await c.load('c-1');
      c.selectTab(1);
      await Future<void>.delayed(Duration.zero);

      await c.loadInvoices();

      expect(repository.invoiceCalls, 2);
    });

    test('opening another customer forgets the loaded tabs', () async {
      final c = cubit();
      addTearDown(c.close);
      await c.load(_modernFoods);
      c.selectTab(2);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await c.load(_noor);

      expect(c.state.deals.status, ViewStatus.initial);
    });
  });
}
