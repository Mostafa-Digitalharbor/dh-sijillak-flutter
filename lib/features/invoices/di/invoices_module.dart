import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/invoices_remote_data_source.dart';
import '../data/repositories/invoices_repository_impl.dart';
import '../domain/entities/invoice_detail.dart';
import '../domain/repositories/invoices_repository.dart';
import '../domain/usecases/get_invoice_draft_use_case.dart';
import '../domain/usecases/get_invoice_use_case.dart';
import '../domain/usecases/get_invoices_use_case.dart';
import '../domain/usecases/get_products_use_case.dart';
import '../domain/usecases/issue_invoice_use_case.dart';
import '../domain/usecases/record_payment_use_case.dart';
import '../presentation/cubit/invoice_cubit.dart';
import '../presentation/cubit/invoices_cubit.dart';
import '../presentation/cubit/new_invoice_cubit.dart';
import '../presentation/cubit/payment_cubit.dart';
import '../presentation/cubit/product_catalog_cubit.dart';
import '../presentation/cubit/payment_done_cubit.dart';

export '../data/datasources/invoices_mock_api.dart';

/// Registers the invoices feature's data, domain and presentation dependencies.
void registerInvoices(GetIt getIt) {
  getIt
    ..registerLazySingleton<InvoicesRemoteDataSource>(
      () => InvoicesRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<InvoicesRepository>(
      () => InvoicesRepositoryImpl(getIt<InvoicesRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetInvoicesUseCase(getIt()))
    ..registerLazySingleton(() => GetInvoiceUseCase(getIt()))
    ..registerLazySingleton(() => GetInvoiceDraftUseCase(getIt()))
    ..registerLazySingleton(() => GetProductsUseCase(getIt()))
    ..registerLazySingleton(() => IssueInvoiceUseCase(getIt()))
    ..registerLazySingleton(() => RecordPaymentUseCase(getIt()))
    ..registerFactory(() => InvoicesCubit(getIt()))
    ..registerFactory(() => InvoiceCubit(getIt()))
    ..registerFactory(() => PaymentDoneCubit(getIt()))
    ..registerFactory(() => NewInvoiceCubit(getIt(), getIt()))
    ..registerFactory(() => ProductCatalogCubit(getIt()))
    ..registerFactoryParam<PaymentCubit, InvoiceDetail, void>(
      (invoice, _) => PaymentCubit(getIt(), invoice: invoice),
    );
}
