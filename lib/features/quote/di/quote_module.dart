import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/quote_remote_data_source.dart';
import '../data/repositories/quote_repository_impl.dart';
import '../domain/repositories/quote_repository.dart';
import '../domain/usecases/confirm_quote_use_case.dart';
import '../domain/usecases/create_quote_for_deal_use_case.dart';
import '../domain/usecases/get_quote_use_case.dart';
import '../presentation/cubit/quote_cubit.dart';

export '../data/datasources/quote_mock_api.dart';

/// Registers the quote feature's data, domain and presentation dependencies.
void registerQuote(GetIt getIt) {
  getIt
    ..registerLazySingleton<QuoteRemoteDataSource>(
      () => QuoteRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<QuoteRepository>(
      () => QuoteRepositoryImpl(getIt<QuoteRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetQuoteUseCase(getIt()))
    ..registerLazySingleton(() => ConfirmQuoteUseCase(getIt()))
    ..registerLazySingleton(() => CreateQuoteForDealUseCase(getIt()))
    ..registerFactory(() => QuoteCubit(getIt(), getIt()));
}
