import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/domain/usecases/get_session_use_case.dart';
import '../../auth/domain/usecases/sign_out_use_case.dart';
import '../data/repositories/preferences_locale_repository.dart';
import '../domain/repositories/locale_repository.dart';
import '../domain/usecases/get_saved_locale_use_case.dart';
import '../domain/usecases/save_locale_use_case.dart';
import '../presentation/cubit/account_cubit.dart';

/// Registers the account feature. Needs the auth feature registered first.
/// The app-wide `LocaleCubit` is created at start-up (it reads the saved
/// language asynchronously) in `configureDependencies`.
void registerAccount(GetIt getIt) {
  getIt
    ..registerLazySingleton<LocaleRepository>(
      () => PreferencesLocaleRepository(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton(
      () => GetSavedLocaleUseCase(getIt<LocaleRepository>()),
    )
    ..registerLazySingleton(() => SaveLocaleUseCase(getIt<LocaleRepository>()))
    ..registerFactory(
      () => AccountCubit(getIt<GetSessionUseCase>(), getIt<SignOutUseCase>()),
    );
}
