import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/usecases/request_otp_use_case.dart';
import '../constants/auth_rules.dart';

enum PasswordStrength { none, weak, medium, strong }

/// The password typed so far and the state of the "send code" request.
class AccountState extends Equatable {
  const AccountState({
    this.password = '',
    this.status = ViewStatus.initial,
    this.failure,
  });

  final String password;
  final ViewStatus status;
  final Failure? failure;

  PasswordStrength get strength {
    if (password.isEmpty) return PasswordStrength.none;
    final mixed =
        AuthRules.digitPattern.hasMatch(password) &&
        AuthRules.letterPattern.hasMatch(password);
    final long =
        password.length >= AuthRules.passwordStrongLength ||
        AuthRules.symbolPattern.hasMatch(password);
    final score = [
      password.length >= AuthRules.passwordMinLength,
      mixed,
      long,
    ].where((met) => met).length;
    return switch (score) {
      >= 3 => PasswordStrength.strong,
      2 => PasswordStrength.medium,
      _ => PasswordStrength.weak,
    };
  }

  /// Number of filled bars in the strength meter.
  int get filledBars => switch (strength) {
    PasswordStrength.none => 0,
    PasswordStrength.weak => 1,
    PasswordStrength.medium => 2,
    PasswordStrength.strong => AuthRules.strengthBars,
  };

  @override
  List<Object?> get props => [password, status, failure];
}

/// Drives registration step 2: the password meter and sending the code.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._requestOtp) : super(const AccountState());

  final RequestOtpUseCase _requestOtp;

  void passwordChanged(String value) => emit(AccountState(password: value));

  /// Asks for a code to be sent to [phone]; [AccountState.status] reports
  /// the outcome.
  Future<void> sendOtp(String phone) async {
    if (state.status.isLoading) return;
    emit(AccountState(password: state.password, status: ViewStatus.loading));
    final result = await _requestOtp(phone);
    if (isClosed) return;
    emit(
      AccountState(
        password: state.password,
        status: result.isSuccess ? ViewStatus.success : ViewStatus.failure,
        failure: result.failureOrNull,
      ),
    );
  }
}
