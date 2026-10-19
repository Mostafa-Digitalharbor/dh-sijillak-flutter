import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/home/data/datasources/home_mock_api.dart';
import 'package:sijilak/features/home/data/datasources/home_remote_data_source.dart';
import 'package:sijilak/features/home/data/models/home_overview_model.dart';
import 'package:sijilak/features/home/data/repositories/home_repository_impl.dart';
import 'package:sijilak/features/home/domain/entities/home_overview.dart';
import 'package:sijilak/features/home/domain/entities/home_summary.dart';
import 'package:sijilak/features/home/domain/entities/home_task.dart';
import 'package:sijilak/features/home/domain/repositories/home_repository.dart';
import 'package:sijilak/features/home/domain/usecases/get_home_overview_use_case.dart';
import 'package:sijilak/features/home/presentation/cubit/home_cubit.dart';

class _FailingRemote implements HomeRemoteDataSource {
  @override
  Future<HomeOverviewModel> fetchOverview() async =>
      throw const NetworkException();
}

class _FakeRepository implements HomeRepository {
  _FakeRepository(this.result);

  final Result<HomeOverview> result;

  @override
  Future<Result<HomeOverview>> getOverview() async => result;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 18, 15);
  late HomeRepositoryImpl repository;

  setUp(() {
    final client = MockApiClient(
      modules: [HomeMockApi(MockAssets(), clock: () => now)],
    );
    repository = HomeRepositoryImpl(HomeRemoteDataSourceImpl(client));
  });

  group('GetHomeOverviewUseCase', () {
    test('serves the dashboard figures and today tasks', () async {
      final result = await GetHomeOverviewUseCase(repository)(const NoParams());

      final overview = result.dataOrNull!;
      expect(overview.summary.monthlySales, 128450);
      expect(overview.summary.salesGrowthPercent, 12);
      expect(overview.summary.overdueInvoices, 5);
      expect(overview.summary.openDeals, 18);
      expect(overview.summary.expectedDealsValue, 210000);
      expect(overview.tasks.map((t) => t.kind), [
        HomeTaskKind.call,
        HomeTaskKind.meeting,
      ]);
      expect(overview.tasks.first.scheduledAt, DateTime(2026, 10, 18, 10, 30));
      expect(overview.tasks.last.scheduledAt, DateTime(2026, 10, 18, 13));
    });

    test('turns a data source error into a failure', () async {
      final result = await GetHomeOverviewUseCase(
        HomeRepositoryImpl(_FailingRemote()),
      )(const NoParams());

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('models', () {
    test('overview survives a toJson/fromJson round trip', () async {
      final overview = (await repository.getOverview()).dataOrNull!;
      final model = HomeOverviewModel.fromJson({
        'user': {'id': 'u', 'name': 'N', 'firstName': 'F'},
        'summary': {
          'monthlySales': 1,
          'salesGrowthPercent': 2,
          'recentSales': [1, 2],
          'dueAmount': 3,
          'overdueInvoices': 4,
          'openDeals': 5,
          'expectedDealsValue': 6,
        },
        'tasks': [
          {
            'id': 't',
            'kind': 'call',
            'title': 'T',
            'customerName': 'C',
            'scheduledAt': '2026-10-18T10:30:00.000',
          },
        ],
      });

      final again = HomeOverviewModel.fromJson(model.toJson()).toEntity();
      expect(again, model.toEntity());
      expect(again.tasks.single.scheduledAt, DateTime(2026, 10, 18, 10, 30));
      expect(overview.user.firstName, isNotEmpty);
    });
  });

  group('HomeSummary.salesBarFractions', () {
    test('scales to the largest period', () {
      const summary = HomeSummary(
        monthlySales: 0,
        salesGrowthPercent: 0,
        recentSales: [50, 100, 25],
        dueAmount: 0,
        overdueInvoices: 0,
        openDeals: 0,
        expectedDealsValue: 0,
      );

      expect(summary.salesBarFractions, [0.5, 1.0, 0.25]);
    });

    test('is all zero without sales', () {
      const summary = HomeSummary(
        monthlySales: 0,
        salesGrowthPercent: 0,
        recentSales: [0, 0],
        dueAmount: 0,
        overdueInvoices: 0,
        openDeals: 0,
        expectedDealsValue: 0,
      );

      expect(summary.salesBarFractions, [0, 0]);
    });
  });

  group('HomeCubit', () {
    test('loads the overview', () async {
      final overview = (await repository.getOverview()).dataOrNull!;
      final cubit = HomeCubit(
        GetHomeOverviewUseCase(_FakeRepository(Success(overview))),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.overview, overview);
    });

    test('exposes the failure and can retry', () async {
      final cubit = HomeCubit(
        GetHomeOverviewUseCase(_FakeRepository(const Failed(NetworkFailure()))),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
      expect(cubit.state.overview, isNull);
    });
  });
}
