import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/biometric_authenticator.dart';
import '../domain/repositories/session_store.dart';
import '../domain/usecases/can_use_biometrics_use_case.dart';
import '../domain/usecases/check_workspace_handle_use_case.dart';
import '../domain/usecases/get_session_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/login_with_biometrics_use_case.dart';
import '../domain/usecases/register_workspace_use_case.dart';
import '../domain/usecases/request_otp_use_case.dart';
import '../domain/usecases/resend_otp_use_case.dart';
import '../domain/usecases/sign_out_use_case.dart';
import '../domain/usecases/verify_otp_use_case.dart';
import '../presentation/cubit/account_cubit.dart';
import '../presentation/cubit/company_cubit.dart';
import '../presentation/cubit/login_cubit.dart';
import '../presentation/cubit/otp_cubit.dart';
import '../presentation/cubit/registration_cubit.dart';

export '../data/datasources/auth_mock_api.dart';

/// Registers the auth feature's data, domain and presentation dependencies.
/// Needs the `SessionStore` and `BiometricAuthenticator` registered first
/// (see `configureDependencies`).
void registerAuth(GetIt getIt) {
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
    )
    ..registerLazySingleton(
      () => CheckWorkspaceHandleUseCase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton(() => RequestOtpUseCase(getIt<AuthRepository>()))
    ..registerLazySingleton(() => ResendOtpUseCase(getIt<AuthRepository>()))
    ..registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepository>()))
    ..registerLazySingleton(
      () => RegisterWorkspaceUseCase(
        getIt<AuthRepository>(),
        getIt<SessionStore>(),
      ),
    )
    ..registerLazySingleton(
      () => LoginUseCase(getIt<AuthRepository>(), getIt<SessionStore>()),
    )
    ..registerLazySingleton(
      () => LoginWithBiometricsUseCase(
        getIt<AuthRepository>(),
        getIt<BiometricAuthenticator>(),
        getIt<SessionStore>(),
      ),
    )
    ..registerLazySingleton(
      () => CanUseBiometricsUseCase(getIt<BiometricAuthenticator>()),
    )
    ..registerLazySingleton(() => GetSessionUseCase(getIt<SessionStore>()))
    ..registerLazySingleton(() => SignOutUseCase(getIt<SessionStore>()))
    ..registerFactory(
      () => LoginCubit(
        getIt<LoginUseCase>(),
        getIt<LoginWithBiometricsUseCase>(),
        getIt<CanUseBiometricsUseCase>(),
      ),
    )
    ..registerFactory(
      () => RegistrationCubit(getIt<RegisterWorkspaceUseCase>()),
    )
    ..registerFactory(() => CompanyCubit(getIt<CheckWorkspaceHandleUseCase>()))
    ..registerFactory(() => AccountCubit(getIt<RequestOtpUseCase>()))
    ..registerFactoryParam<OtpCubit, String, void>(
      (phone, _) => OtpCubit(
        getIt<VerifyOtpUseCase>(),
        getIt<ResendOtpUseCase>(),
        phone: phone,
      ),
    );
}
