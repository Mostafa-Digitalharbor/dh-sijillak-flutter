import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_config.dart';
import '../../core/error/crash_reporter.dart';
import '../../core/l10n/l10n.dart';
import '../../core/network/session_events.dart';
import '../../features/account/di/account_module.dart';
import '../../features/account/domain/entities/app_language.dart';
import '../../features/account/domain/usecases/get_saved_locale_use_case.dart';
import '../../features/account/domain/usecases/save_locale_use_case.dart';
import '../../features/account/presentation/cubit/locale_cubit.dart';
import '../../features/auth/data/repositories/local_auth_biometric_authenticator.dart';
import '../../features/auth/data/repositories/secure_session_store.dart';
import '../../features/auth/di/auth_module.dart';
import '../../features/auth/domain/repositories/biometric_authenticator.dart';
import '../../features/auth/domain/repositories/session_store.dart';
import '../../features/customer/di/customer_module.dart';
import '../../features/home/di/home_module.dart';
import '../../features/invoices/di/invoices_module.dart';
import '../../features/notifications/di/notifications_module.dart';
import '../../features/pipeline/di/pipeline_module.dart';
import '../../features/quote/di/quote_module.dart';
import '../../features/search/di/search_module.dart';
import 'backend_registration.dart';

final getIt = GetIt.instance;

/// Keychain / Keystore settings of the production secure storage.
const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);

/// Composition root: the only place that knows every concrete class.
///
/// The backend is chosen by configuration: the in-app mock
/// ([useMockBackend], the default) or [HttpApiClient] at [apiBaseUrl]
/// (`--dart-define-from-file=env/<name>.json`). Everything above the
/// `ApiClient` is identical in both cases.
///
/// The remaining parameters are seams for tests and for plugging services in:
/// [latency] of the mock, the [secureStorage] and [biometrics] implementations
/// (defaults: the platform keystore and the device `local_auth` check) and the
/// [crashReporter] (see `CrashReporter` for Sentry / Crashlytics).
Future<void> configureDependencies({
  Duration latency = AppConfig.mockLatency,
  bool useMockBackend = AppConfig.useMockBackend,
  String apiBaseUrl = AppConfig.apiBaseUrl,
  FlutterSecureStorage? secureStorage,
  BiometricAuthenticator? biometrics,
  CrashReporter crashReporter = const ConsoleCrashReporter(),
}) async {
  AppConfig.validateBackend(
    useMockBackend: useMockBackend,
    apiBaseUrl: apiBaseUrl,
  );
  await getIt.reset();
  final preferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerSingleton<CrashReporter>(crashReporter)
    ..registerSingleton<SessionEvents>(
      SessionEvents(),
      dispose: (events) => events.dispose(),
    )
    ..registerSingleton<SessionStore>(
      await SecureSessionStore.open(
        storage: secureStorage ?? _secureStorage,
        legacyPreferences: preferences,
        reporter: crashReporter,
      ),
    )
    ..registerSingleton<BiometricAuthenticator>(
      biometrics ??
          LocalAuthBiometricAuthenticator(
            LocalAuthentication(),
            reason: _biometricReason,
          ),
    );
  if (useMockBackend) {
    registerMockBackend(getIt, latency: latency);
  } else {
    registerHttpBackend(getIt, baseUrl: apiBaseUrl);
  }
  registerAuth(getIt);
  registerHome(getIt);
  registerPipeline(getIt);
  registerCustomer(getIt);
  registerQuote(getIt);
  registerInvoices(getIt);
  registerNotifications(getIt);
  registerSearch(getIt);
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

/// The sentence of the system biometric prompt, in the language in use.
String _biometricReason() =>
    lookupAppLocalizations(Locale(getIt<LocaleCubit>().state.code))
        .biometricReason;
