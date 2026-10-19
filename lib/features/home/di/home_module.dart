import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/home_remote_data_source.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_home_overview_use_case.dart';
import '../presentation/cubit/home_cubit.dart';

export '../data/datasources/home_mock_api.dart';

/// Registers the home feature's data, domain and presentation dependencies.
void registerHome(GetIt getIt) {
  getIt
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetHomeOverviewUseCase(getIt()))
    ..registerFactory(() => HomeCubit(getIt()));
}
