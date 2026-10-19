import '../../../../core/utils/result.dart';
import '../../domain/entities/home_overview.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeRemoteDataSource _dataSource;

  @override
  Future<Result<HomeOverview>> getOverview() =>
      Result.guard(() async => (await _dataSource.fetchOverview()).toEntity());
}
