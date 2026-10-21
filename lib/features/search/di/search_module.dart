import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/search_remote_data_source.dart';
import '../data/repositories/preferences_recent_searches_repository.dart';
import '../data/repositories/search_repository_impl.dart';
import '../domain/repositories/recent_searches_repository.dart';
import '../domain/repositories/search_repository.dart';
import '../domain/usecases/clear_recent_searches_use_case.dart';
import '../domain/usecases/get_recent_searches_use_case.dart';
import '../domain/usecases/save_recent_search_use_case.dart';
import '../domain/usecases/search_use_case.dart';
import '../presentation/cubit/search_cubit.dart';

export '../data/datasources/search_mock_api.dart';

/// Registers the search feature's data, domain and presentation dependencies.
void registerSearch(GetIt getIt) {
  getIt
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(getIt<SearchRemoteDataSource>()),
    )
    ..registerLazySingleton<RecentSearchesRepository>(
      () => PreferencesRecentSearchesRepository(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton(() => SearchUseCase(getIt()))
    ..registerLazySingleton(() => GetRecentSearchesUseCase(getIt()))
    ..registerLazySingleton(() => SaveRecentSearchUseCase(getIt()))
    ..registerLazySingleton(() => ClearRecentSearchesUseCase(getIt()))
    ..registerFactory(() => SearchCubit(getIt(), getIt(), getIt(), getIt()));
}
