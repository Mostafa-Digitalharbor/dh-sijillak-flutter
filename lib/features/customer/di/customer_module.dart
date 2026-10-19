import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/customer_remote_data_source.dart';
import '../data/repositories/customer_repository_impl.dart';
import '../domain/repositories/customer_repository.dart';
import '../domain/usecases/get_customer_deals_use_case.dart';
import '../domain/usecases/get_customer_invoices_use_case.dart';
import '../domain/usecases/get_customer_use_case.dart';
import '../domain/usecases/get_customers_use_case.dart';
import '../presentation/cubit/customer_cubit.dart';
import '../presentation/cubit/customers_cubit.dart';

export '../data/datasources/customer_mock_api.dart';

/// Registers the customer feature's data, domain and presentation dependencies.
void registerCustomer(GetIt getIt) {
  getIt
    ..registerLazySingleton<CustomerRemoteDataSource>(
      () => CustomerRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<CustomerRepository>(
      () => CustomerRepositoryImpl(getIt<CustomerRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetCustomersUseCase(getIt()))
    ..registerLazySingleton(() => GetCustomerUseCase(getIt()))
    ..registerLazySingleton(() => GetCustomerDealsUseCase(getIt()))
    ..registerLazySingleton(() => GetCustomerInvoicesUseCase(getIt()))
    ..registerFactory(() => CustomersCubit(getIt()))
    ..registerFactory(() => CustomerCubit(getIt(), getIt(), getIt()));
}
