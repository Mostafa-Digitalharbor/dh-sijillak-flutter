import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/customer/data/datasources/customer_mock_api.dart';
import 'package:sijilak/features/customer/data/datasources/customer_remote_data_source.dart';
import 'package:sijilak/features/customer/data/models/customer_deal_model.dart';
import 'package:sijilak/features/customer/data/models/customer_invoice_model.dart';
import 'package:sijilak/features/customer/data/models/customer_model.dart';
import 'package:sijilak/features/customer/data/models/customer_summary_model.dart';
import 'package:sijilak/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:sijilak/features/customer/domain/entities/customer.dart';
import 'package:sijilak/features/customer/domain/entities/customer_activity.dart';
import 'package:sijilak/features/customer/domain/entities/customer_deal.dart';
import 'package:sijilak/features/customer/domain/entities/customer_invoice.dart';
import 'package:sijilak/features/customer/domain/entities/customer_summary.dart';
import 'package:sijilak/features/customer/domain/repositories/customer_repository.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_deals_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_invoices_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_use_case.dart';
import 'package:sijilak/features/customer/presentation/cubit/customer_cubit.dart';

class _FakeRepository implements CustomerRepository {
  _FakeRepository(this.result);

  final Result<Customer> result;
  final requested = <String>[];

  @override
  Future<Result<Customer>> getCustomer(String id) async {
    requested.add(id);
    return result;
  }

  @override
  Future<Result<List<CustomerSummary>>> getCustomers(String query) async =>
      const Success([]);

  @override
  Future<Result<List<CustomerDeal>>> getDeals(String id) async =>
      const Success([]);

  @override
  Future<Result<List<CustomerInvoice>>> getInvoices(String id) async =>
      const Success([]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 18, 15);
  late GetCustomerUseCase useCase;

  setUp(() {
    final client = MockApiClient(
      modules: [CustomerMockApi(MockAssets(), clock: () => now)],
    );
    useCase = GetCustomerUseCase(
      CustomerRepositoryImpl(CustomerRemoteDataSourceImpl(client)),
    );
  });

  group('GetCustomerUseCase', () {
    test('returns the profile, stats and timeline', () async {
      final customer = (await useCase('c-modern-foods')).dataOrNull!;

      expect(customer.totalSales, 215000);
      expect(customer.amountDue, 12650);
      expect(customer.openDeals, 2);
      expect(customer.activity.map((a) => a.kind), [
        CustomerActivityKind.quoteSent,
        CustomerActivityKind.call,
        CustomerActivityKind.invoiceOverdue,
      ]);
    });

    test('timestamps are relative to the current time', () async {
      final activity = (await useCase('c-modern-foods')).dataOrNull!.activity;

      expect(activity[0].at, now.subtract(const Duration(hours: 2)));
      expect(activity[0].amount, 65000);
      expect(activity[1].at, DateTime(2026, 10, 17, 12));
      expect(activity[1].detail, isNotNull);
      expect(activity[2].at, DateTime(2026, 10, 13, 12));
    });

    test('an unknown customer is a not-found failure', () async {
      final result = await useCase('missing');

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('CustomerModel', () {
    test('survives a toJson/fromJson round trip', () async {
      final customer = (await useCase('c-modern-foods')).dataOrNull!;
      final model = CustomerModel.fromJson({
        'id': customer.id,
        'name': customer.name,
        'location': customer.location,
        'city': customer.city,
        'sector': customer.sector,
        'phone': customer.phone,
        'email': customer.email,
        'address': customer.address,
        'commercialRegistration': customer.commercialRegistration,
        'customerSince': customer.customerSince.toIso8601String(),
        'accountOwner': customer.accountOwner,
        'vatNumber': customer.vatNumber,
        'totalSales': customer.totalSales,
        'amountDue': customer.amountDue,
        'openDeals': customer.openDeals,
        'activity': [
          for (final a in customer.activity)
            {
              'id': a.id,
              'kind': a.kind.name,
              'title': a.title,
              'at': a.at.toIso8601String(),
              if (a.detail != null) 'detail': a.detail,
              if (a.amount != null) 'amount': a.amount,
            },
        ],
      });

      expect(CustomerModel.fromJson(model.toJson()).toEntity(), customer);
    });
  });

  group('CustomerCubit', () {
    test('loads the requested customer', () async {
      final customer = (await useCase('c-modern-foods')).dataOrNull!;
      final repository = _FakeRepository(Success(customer));
      final cubit = _cubit(repository);
      addTearDown(cubit.close);

      await cubit.load('c-modern-foods');

      expect(repository.requested, ['c-modern-foods']);
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.customer, customer);
    });

    test('reports a failure and retries the same customer', () async {
      final repository = _FakeRepository(const Failed(NetworkFailure()));
      final cubit = _cubit(repository);
      addTearDown(cubit.close);

      await cubit.load('c-1');
      await cubit.load();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
      expect(repository.requested, ['c-1', 'c-1']);
    });

    test('keeps the selected tab across reloads', () async {
      final customer = (await useCase('c-modern-foods')).dataOrNull!;
      final cubit = _cubit(_FakeRepository(Success(customer)));
      addTearDown(cubit.close);

      await cubit.load('c-modern-foods');
      cubit.selectTab(2);
      await cubit.load();

      expect(cubit.state.tab, 2);
    });
  });

  test('repository maps data source errors to failures', () async {
    final repository = CustomerRepositoryImpl(_ThrowingRemote());

    expect((await repository.getCustomer('x')).failureOrNull, isNotNull);
  });
}

CustomerCubit _cubit(CustomerRepository repository) => CustomerCubit(
  GetCustomerUseCase(repository),
  GetCustomerDealsUseCase(repository),
  GetCustomerInvoicesUseCase(repository),
);

class _ThrowingRemote implements CustomerRemoteDataSource {
  @override
  Future<CustomerModel> fetchCustomer(String id) async =>
      throw StateError('boom');

  @override
  Future<List<CustomerSummaryModel>> fetchCustomers(String query) async =>
      throw StateError('boom');

  @override
  Future<List<CustomerDealModel>> fetchDeals(String id) async =>
      throw StateError('boom');

  @override
  Future<List<CustomerInvoiceModel>> fetchInvoices(String id) async =>
      throw StateError('boom');
}
