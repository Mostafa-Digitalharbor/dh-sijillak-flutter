import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/otp_verification.dart';
import '../../domain/usecases/resend_otp_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';
import '../constants/auth_rules.dart';

/// The entered code, the resend countdown and the state of the last request.
class OtpState extends Equatable {
  const OtpState({
    this.code = '',
    this.secondsLeft = AuthRules.otpResendSeconds,
    this.status = ViewStatus.initial,
    this.failure,
  });

  final String code;
  final int secondsLeft;

  /// Verification or resend in flight ([ViewStatus.loading]) or its outcome.
  final ViewStatus status;
  final Failure? failure;

  bool get isComplete => code.length == AuthRules.otpLength;
  bool get canResend => secondsLeft == 0;

  /// Copy with new values; [failure] is only kept when passed again.
  OtpState copyWith({
    String? code,
    int? secondsLeft,
    ViewStatus? status,
    Failure? failure,
  }) => OtpState(
    code: code ?? this.code,
    secondsLeft: secondsLeft ?? this.secondsLeft,
    status: status ?? this.status,
    failure: failure,
  );

  @override
  List<Object?> get props => [code, secondsLeft, status, failure];
}

/// Drives the verification-code step: keypad input, the resend timer and
/// the verify / resend requests for [phone].
class OtpCubit extends Cubit<OtpState> {
  OtpCubit(
    this._verifyOtp,
    this._resendOtp, {
    required this.phone,
    this.resendSeconds = AuthRules.otpResendSeconds,
    this.tick = AppDurations.otpTick,
  }) : super(OtpState(secondsLeft: resendSeconds)) {
    _startTimer();
  }

  final String phone;
  final VerifyOtpUseCase _verifyOtp;
  final ResendOtpUseCase _resendOtp;

  /// Length of the countdown before a new code may be requested.
  final int resendSeconds;

  /// Interval at which the countdown decreases.
  final Duration tick;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(tick, (t) {
      if (state.secondsLeft <= 1) {
        t.cancel();
        emit(state.copyWith(secondsLeft: 0, status: state.status));
      } else {
        emit(
          state.copyWith(
            secondsLeft: state.secondsLeft - 1,
            status: state.status,
          ),
        );
      }
    });
  }

  void digitPressed(String digit) {
    if (state.code.length < AuthRules.otpLength && !state.status.isLoading) {
      emit(
        state.copyWith(code: state.code + digit, status: ViewStatus.initial),
      );
    }
  }

  void deletePressed() {
    if (state.code.isNotEmpty && !state.status.isLoading) {
      emit(
        state.copyWith(
          code: state.code.substring(0, state.code.length - 1),
          status: ViewStatus.initial,
        ),
      );
    }
  }

  /// Checks the entered code; [OtpState.status] reports the outcome.
  Future<void> verify() async {
    if (!state.isComplete || state.status.isLoading) return;
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _verifyOtp(
      OtpVerification(phone: phone, code: state.code),
    );
    if (isClosed) return;
    emit(
      state.copyWith(
        status: result.isSuccess ? ViewStatus.success : ViewStatus.failure,
        failure: result.failureOrNull,
      ),
    );
  }

  /// Requests a new code and restarts the countdown once it was sent.
  Future<void> resend() async {
    if (!state.canResend || state.status.isLoading) return;
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _resendOtp(phone);
    if (isClosed) return;
    if (result.isSuccess) {
      emit(OtpState(secondsLeft: resendSeconds));
      _startTimer();
    } else {
      emit(
        state.copyWith(
          status: ViewStatus.failure,
          failure: result.failureOrNull,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
