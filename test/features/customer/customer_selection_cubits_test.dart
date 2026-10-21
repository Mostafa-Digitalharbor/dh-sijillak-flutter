import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/customer/data/datasources/customer_mock_api.dart';
import 'package:sijilak/features/customer/data/datasources/customer_remote_data_source.dart';
import 'package:sijilak/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:sijilak/features/customer/domain/entities/customer_summary.dart';
import 'package:sijilak/features/customer/domain/entities/new_customer.dart';
import 'package:sijilak/features/customer/domain/usecases/create_customer_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_deals_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customers_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_invoices_use_case.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_remote_data_source.dart';
import 'package:sijilak/features/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_draft_use_case.dart';
import 'package:sijilak/features/invoices/domain/usecases/issue_invoice_use_case.dart';
import 'package:sijilak/features/invoices/presentation/cubit/new_invoice_cubit.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_mock_api.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_remote_data_source.dart';
import 'package:sijilak/features/pipeline/data/repositories/pipeline_repository_impl.dart';
import 'package:sijilak/features/pipeline/domain/entities/lead_party.dart';
import 'package:sijilak/features/pipeline/domain/usecases/create_deal_use_case.dart';
import 'package:sijilak/features/pipeline/domain/usecases/get_lead_defaults_use_case.dart';
import 'package:sijilak/features/pipeline/presentation/cubit/new_lead_cubit.dart';
import 'package:sijilak/features/quote/data/datasources/quote_mock_api.dart';
import 'package:sijilak/features/quote/data/datasources/quote_remote_data_source.dart';
import 'package:sijilak/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:sijilak/features/quote/domain/usecases/create_quote_for_deal_use_case.dart';

import '../../helpers/fake_customer_repository.dart';

const _united = 'c-united-supplies';
const _unitedName = 'مؤسسة التوريدات المتحدة';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 18, 15);
  late CustomerRepositoryImpl customers;
  late NewLeadCubit lead;
  late GetCustomerDealsUseCase getDeals;

  setUp(() {
    final assets = MockAssets();
    final client = MockApiClient(
      modules: [
        CustomerMockApi(assets, clock: () => now),
        PipelineMockApi(assets, clock: () => now),
        QuoteMockApi(assets, clock: () => now),
      ],
    );
    customers = CustomerRepositoryImpl(CustomerRemoteDataSourceImpl(client));
    final pipeline = PipelineRepositoryImpl(
      PipelineRemoteDataSourceImpl(client),
    );
    getDeals = GetCustomerDealsUseCase(customers);
    lead = NewLeadCubit(
      GetLeadDefaultsUseCase(pipeline),
      CreateDealUseCase(pipeline),
      CreateQuoteForDealUseCase(
        QuoteRepositoryImpl(QuoteRemoteDataSourceImpl(client)),
      ),
      GetCustomerUseCase(customers),
    );
    addTearDown(lead.close);
  });

  group('NewLeadCubit customer', () {
    test('starts with the default customer', () async {
      await lead.load();

      expect(lead.state.customer!.id, 'c-modern-foods');
      expect(lead.state.canSubmit, isTrue);
    });

    test('can start for a given customer', () async {
      await lead.load(_united);

      expect(lead.state.status, ViewStatus.success);
      expect(lead.state.customer!.id, _united);
      expect(lead.state.customer!.name, _unitedName);
      expect(lead.state.customer!.subtitle, 'جدة · قطاع التجارة والتوزيع');
    });

    test('an unknown given customer is a failure the retry keeps', () async {
      await lead.load('c-ghost');

      expect(lead.state.status, ViewStatus.failure);
      expect(lead.state.failure, isA<NotFoundFailure>());
      expect(lead.state.canSubmit, isFalse);
    });

    test('the deal is saved for the selected customer', () async {
      await lead.load();
      lead.selectCustomer(const LeadParty(id: _united, name: _unitedName));
      lead
        ..titleController.text = 'Chosen customer deal'
        ..valueController.text = '9000';

      await lead.submit(expectedClose: null, createQuote: false);

      expect(lead.state.submitStatus, ViewStatus.success);
      expect(
        (await getDeals(_united)).dataOrNull!.map((d) => d.title),
        contains('Chosen customer deal'),
      );
      expect(
        (await getDeals('c-modern-foods')).dataOrNull!.map((d) => d.title),
        isNot(contains('Chosen customer deal')),
      );
    });

    test('a customer created on the fly can be selected and used', () async {
      final created = (await CreateCustomerUseCase(customers)(
        const NewCustomer(name: 'Fresh customer'),
      )).dataOrNull!;
      await lead.load();
      lead.selectCustomer(LeadParty(id: created.id, name: created.name));
      lead
        ..titleController.text = 'First deal'
        ..valueController.text = '1000';

      await lead.submit(expectedClose: null, createQuote: true);

      expect(lead.state.submitStatus, ViewStatus.success);
      expect(lead.state.quoteNumber, isNotNull);
      expect((await getDeals(created.id)).dataOrNull, hasLength(1));
    });
  });

  group('customer list for the picker', () {
    test('lists customers with the tax number of each', () async {
      final list = (await GetCustomersUseCase(customers)('')).dataOrNull!;

      final modern = list.firstWhere((c) => c.id == 'c-modern-foods');
      expect(modern.vatNumber, isNotEmpty);
    });

    test('a profile converts to a list row', () async {
      final profile = fakeCustomer(id: 'c-9', name: 'N', location: 'L');

      expect(
        profile.toSummary(),
        const CustomerSummary(
          id: 'c-9',
          name: 'N',
          location: 'L',
          openDeals: 0,
          amountDue: 0,
        ),
      );
    });
  });

  group('NewInvoiceCubit customer', () {
    test('the draft is billed to the picked customer', () async {
      final assets = MockAssets();
      final client = MockApiClient(
        modules: [
          CustomerMockApi(assets, clock: () => now),
          InvoicesMockApi(assets, clock: () => now),
          QuoteMockApi(assets, clock: () => now),
        ],
      );
      final invoices = InvoicesRepositoryImpl(
        InvoicesRemoteDataSourceImpl(client),
      );
      final cubit = NewInvoiceCubit(
        GetInvoiceDraftUseCase(invoices),
        IssueInvoiceUseCase(invoices),
      );
      addTearDown(cubit.close);
      final repository = CustomerRepositoryImpl(
        CustomerRemoteDataSourceImpl(client),
      );
      final golden = (await GetCustomersUseCase(repository)('الذهبية'))
          .dataOrNull!
          .single;
      await cubit.load();
      final before = cubit.state.draft!;

      cubit.changeCustomer(name: golden.name, vatNumber: golden.vatNumber);

      expect(cubit.state.draft!.customer, golden.name);
      expect(cubit.state.draft!.vatNumber, golden.vatNumber);
      expect(cubit.state.draft!.lines, before.lines);

      await cubit.issue();

      expect(cubit.state.issued!.customer, golden.name);
      final shown = (await GetCustomerInvoicesUseCase(repository)(golden.id))
          .dataOrNull!;
      expect(shown.first.number, cubit.state.issued!.number);
    });

    test('changing the customer before the draft loads does nothing', () {
      final invoices = InvoicesRepositoryImpl(
        InvoicesRemoteDataSourceImpl(MockApiClient(modules: const [])),
      );
      final cubit = NewInvoiceCubit(
        GetInvoiceDraftUseCase(invoices),
        IssueInvoiceUseCase(invoices),
      );
      addTearDown(cubit.close);

      cubit.changeCustomer(name: 'X', vatNumber: '1');

      expect(cubit.state.draft, isNull);
    });
  });
}
