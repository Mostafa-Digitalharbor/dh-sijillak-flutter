import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/login_with_biometrics_use_case.dart';

/// Typed credentials and the state of the sign-in request.
class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = ViewStatus.initial,
    this.failure,
  });

  final String email;
  final String password;
  final ViewStatus status;
  final Failure? failure;

  @override
  List<Object?> get props => [email, password, status, failure];
}

/// Drives the sign-in screen.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login, this._loginWithBiometrics)
    : super(const LoginState());

  final LoginUseCase _login;
  final LoginWithBiometricsUseCase _loginWithBiometrics;

  void emailChanged(String value) =>
      emit(LoginState(email: value, password: state.password));

  void passwordChanged(String value) =>
      emit(LoginState(email: state.email, password: value));

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
      ),
    );
  }
}
