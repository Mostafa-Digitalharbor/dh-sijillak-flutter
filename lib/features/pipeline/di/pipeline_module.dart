import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/pipeline_remote_data_source.dart';
import '../data/repositories/pipeline_repository_impl.dart';
import '../domain/repositories/pipeline_repository.dart';
import '../domain/usecases/create_deal_use_case.dart';
import '../domain/usecases/get_lead_defaults_use_case.dart';
import '../domain/usecases/get_pipeline_use_case.dart';
import '../presentation/cubit/new_lead_cubit.dart';
import '../presentation/cubit/pipeline_cubit.dart';

export '../data/datasources/pipeline_mock_api.dart';

/// Registers the pipeline feature's data, domain and presentation dependencies.
void registerPipeline(GetIt getIt) {
  getIt
    ..registerLazySingleton<PipelineRemoteDataSource>(
      () => PipelineRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<PipelineRepository>(
      () => PipelineRepositoryImpl(getIt<PipelineRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetPipelineUseCase(getIt()))
    ..registerLazySingleton(() => GetLeadDefaultsUseCase(getIt()))
    ..registerLazySingleton(() => CreateDealUseCase(getIt()))
    ..registerFactory(() => PipelineCubit(getIt()))
    ..registerFactory(() => NewLeadCubit(getIt(), getIt(), getIt(), getIt()));
}
