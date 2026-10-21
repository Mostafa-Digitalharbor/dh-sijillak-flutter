import 'package:get_it/get_it.dart';

import '../../core/constants/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/network/http/http_api_client.dart';
import '../../core/network/http/token_storage.dart';
import '../../core/network/mock/mock_api_client.dart';
import '../../core/network/mock/mock_assets.dart';
import '../../core/network/session_events.dart';
import '../../features/account/presentation/cubit/locale_cubit.dart';
import '../../features/auth/data/datasources/auth_endpoints.dart';
import '../../features/auth/data/repositories/session_token_storage.dart';
import '../../features/auth/di/auth_module.dart';
import '../../features/customer/di/customer_module.dart';
import '../../features/home/di/home_module.dart';
import '../../features/invoices/di/invoices_module.dart';
import '../../features/notifications/di/notifications_module.dart';
import '../../features/pipeline/di/pipeline_module.dart';
import '../../features/quote/di/quote_module.dart';
import '../../features/search/di/search_module.dart';
import '../../features/auth/domain/repositories/session_store.dart';

/// Registers the in-app fake backend: fixtures plus in-memory state, with
/// [latency] simulating the network round-trip.
void registerMockBackend(GetIt getIt, {required Duration latency}) {
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
        NotificationsMockApi(assets),
        SearchMockApi(assets),
      ],
    ),
  );
}

/// Registers the HTTP client for the real backend at [baseUrl]. Needs the
/// `SessionStore`, `SessionEvents` and (lazily, at request time) the
/// `LocaleCubit` registered.
void registerHttpBackend(GetIt getIt, {required String baseUrl}) {
  AppConfig.validateBackend(useMockBackend: false, apiBaseUrl: baseUrl);
  getIt.registerSingleton<TokenStorage>(
    SessionTokenStorage(getIt<SessionStore>()),
  );
  getIt.registerSingleton<ApiClient>(
    HttpApiClient.create(
      baseUrl: baseUrl,
      tokens: getIt<TokenStorage>(),
      events: getIt<SessionEvents>(),
      languageCode: () => getIt<LocaleCubit>().state.code,
      refreshPath: AuthEndpoints.refresh,
    ),
  );
}
