import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/customer/data/datasources/customer_mock_api.dart';
import 'package:sijilak/features/customer/data/datasources/customer_mock_store.dart';
import 'package:sijilak/features/customer/data/datasources/customer_remote_data_source.dart';
import 'package:sijilak/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:sijilak/features/customer/domain/entities/new_customer.dart';
import 'package:sijilak/features/customer/domain/usecases/create_customer_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_deals_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_invoices_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customers_use_case.dart';
import 'package:sijilak/features/customer/presentation/cubit/deal_picker_cubit.dart';
import 'package:sijilak/features/customer/presentation/cubit/new_customer_cubit.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_remote_data_source.dart';
import 'package:sijilak/features/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_draft.dart';
import 'package:sijilak/features/invoices/domain/usecases/issue_invoice_use_case.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_mock_api.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_remote_data_source.dart';
import 'package:sijilak/features/pipeline/data/repositories/pipeline_repository_impl.dart';
import 'package:sijilak/features/pipeline/domain/entities/deal_stage.dart';
import 'package:sijilak/features/pipeline/domain/entities/new_deal.dart';
import 'package:sijilak/features/pipeline/domain/usecases/create_deal_use_case.dart';

import '../../helpers/fake_customer_repository.dart';

const _noor = 'c-noor-trading';
const _newName = 'شركة البناء الحديثة';

NewDeal _deal(String customerId, {String title = 'Fresh deal'}) => NewDeal(
  title: title,
  customerId: customerId,
  ownerId: 'u-1',
  value: 5000,
  stage: DealStage.qualified,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 18, 15);
  late MockAssets assets;
  late CustomerRepositoryImpl repository;
  late CreateCustomerUseCase createCustomer;
  late GetCustomersUseCase getCustomers;
  late GetCustomerUseCase getCustomer;
  late GetCustomerDealsUseCase getDeals;
  late GetCustomerInvoicesUseCase getInvoices;
  late CreateDealUseCase createDeal;
  late IssueInvoiceUseCase issueInvoice;

  setUp(() {
    assets = MockAssets();
    final client = MockApiClient(
      modules: [
        CustomerMockApi(assets, clock: () => now),
        PipelineMockApi(assets, clock: () => now),
        InvoicesMockApi(assets, clock: () => now),
      ],
    );
    repository = CustomerRepositoryImpl(CustomerRemoteDataSourceImpl(client));
    createCustomer = CreateCustomerUseCase(repository);
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

  group('CustomerMockStore', () {
    test('is shared by everything built on the same assets', () {
      expect(
        identical(CustomerMockStore.of(assets), CustomerMockStore.of(assets)),
        isTrue,
      );
      expect(
        identical(
          CustomerMockStore.of(assets),
          CustomerMockStore.of(MockAssets()),
        ),
        isFalse,
      );
    });

    test('a fresh composition root starts from the fixtures again', () async {
      await createCustomer(const NewCustomer(name: _newName));

      final other = CustomerRepositoryImpl(
        CustomerRemoteDataSourceImpl(
          MockApiClient(modules: [CustomerMockApi(MockAssets())]),
        ),
      );

      expect((await GetCustomersUseCase(other)('')).dataOrNull, hasLength(6));
    });
  });

  group('CreateCustomerUseCase', () {
    test('returns the created profile with a generated id', () async {
      final customer = (await createCustomer(
        const NewCustomer(
          name: '  $_newName ',
          phone: '0500000000',
          email: 'info@build.sa',
          city: 'الرياض',
          sector: 'مقاولات',
        ),
      )).dataOrNull!;

      expect(customer.id, startsWith('c-'));
      expect(customer.name, _newName);
      expect(customer.phone, '0500000000');
      expect(customer.email, 'info@build.sa');
      expect(customer.location, 'الرياض · مقاولات');
      expect(customer.openDeals, 0);
      expect(customer.activity, isEmpty);
      expect(customer.customerSince, DateTime(2026, 10, 18));
    });

    test('ids are unique', () async {
      final first = (await createCustomer(const NewCustomer(name: 'A')))
          .dataOrNull!;
      final second = (await createCustomer(const NewCustomer(name: 'B')))
          .dataOrNull!;

      expect(first.id, isNot(second.id));
    });

    test('only the name is required; the location skips blanks', () async {
      final onlyCity = (await createCustomer(
        const NewCustomer(name: 'A', city: 'جدة'),
      )).dataOrNull!;
      final bare = (await createCustomer(const NewCustomer(name: 'B')))
          .dataOrNull!;

      expect(onlyCity.location, 'جدة');
      expect(bare.location, isEmpty);
    });

    test('a blank name is a validation failure', () async {
      final failure = (await createCustomer(const NewCustomer(name: '   ')))
          .failureOrNull;

      expect(failure, isA<ValidationFailure>());
      expect((failure! as ValidationFailure).fields, {'name': 'required'});
      expect((await getCustomers('')).dataOrNull, hasLength(6));
    });

    test('an email without an at sign is a validation failure', () async {
      final failure = (await createCustomer(
        const NewCustomer(name: 'A', email: 'nope'),
      )).failureOrNull;

      expect((failure! as ValidationFailure).fields, {'email': 'invalid'});
    });

    test('the new customer is listed, searchable and has a profile', () async {
      final created = (await createCustomer(
        const NewCustomer(name: _newName, city: 'الخبر'),
      )).dataOrNull!;

      final all = (await getCustomers('')).dataOrNull!;
      expect(all, hasLength(7));
      expect(all.first.id, created.id);
      expect((await getCustomers('البناء')).dataOrNull!.map((c) => c.id), [
        created.id,
      ]);
      final profile = (await getCustomer(created.id)).dataOrNull!;
      expect(profile.name, _newName);
      expect(profile.city, 'الخبر');
      expect(profile.toSummary().id, created.id);
    });

    test('a new customer starts with no deals and no invoices', () async {
      final created = (await createCustomer(const NewCustomer(name: 'A')))
          .dataOrNull!;

      expect((await getDeals(created.id)).dataOrNull, isEmpty);
      expect((await getInvoices(created.id)).dataOrNull, isEmpty);
    });
  });

  group('pipeline sharing the customers', () {
    test('a customer without deals can get one', () async {
      expect((await getDeals(_noor)).dataOrNull, isEmpty);

      final deal = (await createDeal(_deal(_noor))).dataOrNull!;

      expect(deal.customerName, 'شركة النور للتجارة');
      expect((await getDeals(_noor)).dataOrNull!.map((d) => d.id), [deal.id]);
    });

    test('a just created customer can get a deal', () async {
      final created = (await createCustomer(const NewCustomer(name: _newName)))
          .dataOrNull!;

      final deal = (await createDeal(_deal(created.id))).dataOrNull!;

      expect(deal.customerName, _newName);
      final deals = (await getDeals(created.id)).dataOrNull!;
      expect(deals.single.title, 'Fresh deal');
    });

    test('an unknown customer is still rejected', () async {
      final failure = (await createDeal(_deal('c-ghost'))).failureOrNull;

      expect((failure! as ValidationFailure).fields, {'customerId': 'unknown'});
    });
  });

  group('invoices sharing the customers', () {
    test('an invoice for a new customer appears in its invoices', () async {
      final created = (await createCustomer(const NewCustomer(name: _newName)))
          .dataOrNull!;

      final issued = (await issueInvoice(
        InvoiceDraft(
          customer: created.name,
          vatNumber: created.vatNumber,
          issueDate: DateTime(2026, 10, 18),
          paymentTermsDays: 30,
          lines: const [DocumentLine(name: 'Service', unitPrice: 1000)],
        ),
      )).dataOrNull!;

      final invoices = (await getInvoices(created.id)).dataOrNull!;
      expect(invoices.map((i) => i.number), [issued.number]);
    });
  });

  group('NewCustomerCubit', () {
    NewCustomerCubit build(FakeCustomerRepository fake) {
      final cubit = NewCustomerCubit(CreateCustomerUseCase(fake));
      addTearDown(cubit.close);
      return cubit;
    }

    test('cannot submit until the name has a letter', () async {
      final fake = FakeCustomerRepository();
      final cubit = build(fake);
      expect(cubit.state.canSubmit, isFalse);

      cubit.nameChanged('   ');
      expect(cubit.state.canSubmit, isFalse);
      await cubit.submit();
      expect(fake.created, isEmpty);

      cubit.nameChanged('Acme');
      expect(cubit.state.canSubmit, isTrue);
    });

    test('submits the trimmed fields and exposes the customer', () async {
      final fake = FakeCustomerRepository();
      final cubit = build(fake);
      cubit
        ..nameChanged(' Acme ')
        ..phoneChanged('050 ')
        ..emailChanged('a@b.sa')
        ..cityChanged(' Riyadh')
        ..sectorChanged('Trade');

      await cubit.submit();

      expect(
        fake.created.single,
        const NewCustomer(
          name: 'Acme',
          phone: '050',
          email: 'a@b.sa',
          city: 'Riyadh',
          sector: 'Trade',
        ),
      );
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.created!.name, 'Acme');
    });

    test('a failure is exposed and the form can be submitted again', () async {
      final cubit = build(
        FakeCustomerRepository(failure: const NetworkFailure()),
      );
      cubit.nameChanged('Acme');

      await cubit.submit();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
      expect(cubit.state.created, isNull);
      expect(cubit.state.canSubmit, isTrue);
    });
  });

  group('DealPickerCubit', () {
    test('lists the open deals of the customer only', () async {
      final cubit = DealPickerCubit(getDeals, 'c-modern-foods');
      addTearDown(cubit.close);

      await cubit.load();

      // d-8 is won, so only d-4 remains.
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.deals.map((d) => d.id), ['d-4']);
    });

    test('a customer without deals gets an empty list', () async {
      final cubit = DealPickerCubit(getDeals, _noor);
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.deals, isEmpty);
    });

    test('a failure is exposed', () async {
      final cubit = DealPickerCubit(
        GetCustomerDealsUseCase(
          FakeCustomerRepository(failure: const NetworkFailure()),
        ),
        'c-1',
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.deals, isEmpty);
    });
  });
}
