import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/network/mock/mock_api_client.dart';
import '../../core/network/mock/mock_assets.dart';
import '../../features/account/di/account_module.dart';
import '../../features/account/domain/entities/app_language.dart';
import '../../features/account/domain/usecases/get_saved_locale_use_case.dart';
import '../../features/account/domain/usecases/save_locale_use_case.dart';
import '../../features/account/presentation/cubit/locale_cubit.dart';
import '../../features/auth/di/auth_module.dart';
import '../../features/customer/di/customer_module.dart';
import '../../features/home/di/home_module.dart';
import '../../features/invoices/di/invoices_module.dart';
import '../../features/pipeline/di/pipeline_module.dart';
import '../../features/quote/di/quote_module.dart';

final getIt = GetIt.instance;

/// Composition root: the only place that knows every concrete class.
///
/// Today the backend is [MockApiClient]. To go live, register an HTTP
/// implementation of `ApiClient` here instead and drop the mock modules.
Future<void> configureDependencies({
  Duration latency = AppConfig.mockLatency,
}) async {
  await getIt.reset();
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  final assets = MockAssets();
  getIt.registerSingleton<ApiClient>(
    MockApiClient(
      latency: latency,
      modules: [
        AuthMockApi(assets),
        HomeMockApi(assets),
        PipelineMockApi(assets),
        CustomerMockApi(assets),
        QuoteMockApi(assets),
        InvoicesMockApi(assets),
      ],
    ),
  );
  registerAuth(getIt);
  registerHome(getIt);
  registerPipeline(getIt);
  registerCustomer(getIt);
  registerQuote(getIt);
  registerInvoices(getIt);
  registerAccount(getIt);
  getIt.registerSingleton<LocaleCubit>(
    await LocaleCubit.restore(
      getIt<GetSavedLocaleUseCase>(),
      getIt<SaveLocaleUseCase>(),
      fallback:
          AppLanguage.fromCode(AppConfig.localeCode) ?? AppLanguage.arabic,
    ),
  );
}
