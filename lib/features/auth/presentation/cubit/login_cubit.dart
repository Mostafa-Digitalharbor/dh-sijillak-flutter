import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/usecases/can_use_biometrics_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/login_with_biometrics_use_case.dart';

/// Typed credentials and the state of the sign-in request.
class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = ViewStatus.initial,
    this.failure,
    this.biometricsAvailable = false,
  });

  final String email;
  final String password;
  final ViewStatus status;
  final Failure? failure;

  /// Whether the device can offer biometric sign-in.
  final bool biometricsAvailable;

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    failure,
    biometricsAvailable,
  ];
}

/// Drives the sign-in screen.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login, this._loginWithBiometrics, this._canUseBiometrics)
    : super(const LoginState());

  final LoginUseCase _login;
  final LoginWithBiometricsUseCase _loginWithBiometrics;
  final CanUseBiometricsUseCase _canUseBiometrics;

  /// Checks whether the device offers biometrics, to show or hide the button.
  Future<void> loadBiometricAvailability() async {
    final available =
        (await _canUseBiometrics(const NoParams())).dataOrNull ?? false;
    if (isClosed) return;
    emit(
      LoginState(
        email: state.email,
        password: state.password,
        status: state.status,
        failure: state.failure,
        biometricsAvailable: available,
      ),
    );
  }

  void emailChanged(String value) => emit(
    LoginState(
      email: value,
      password: state.password,
      biometricsAvailable: state.biometricsAvailable,
    ),
  );

  void passwordChanged(String value) => emit(
    LoginState(
      email: state.email,
      password: value,
      biometricsAvailable: state.biometricsAvailable,
    ),
  );

  /// Signs in with the typed email and password.
  Future<void> signIn() => _submit(
    () =>
        _login(LoginCredentials(email: state.email, password: state.password)),
  );

  /// Signs in with the device's biometric check.
  Future<void> signInWithBiometrics() =>
      _submit(() => _loginWithBiometrics(const NoParams()));

  Future<void> _submit(Future<Result<AuthSession>> Function() request) async {
    if (state.status.isLoading) return;
    emit(
      LoginState(
        email: state.email,
        password: state.password,
        status: ViewStatus.loading,
        biometricsAvailable: state.biometricsAvailable,
      ),
    );
    final result = await request();
    if (isClosed) return;
    emit(
      LoginState(
        email: state.email,
        password: state.password,
        status: result.isSuccess ? ViewStatus.success : ViewStatus.failure,
        failure: result.failureOrNull,
        biometricsAvailable: state.biometricsAvailable,
      ),
    );
  }
}
