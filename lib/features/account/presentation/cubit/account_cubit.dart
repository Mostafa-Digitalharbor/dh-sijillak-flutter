import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../auth/domain/usecases/get_session_use_case.dart';
import '../../../auth/domain/usecases/sign_out_use_case.dart';

/// The signed-in session shown on the account screen and its sign-out result.
class AccountState extends Equatable {
  const AccountState({
    this.status = ViewStatus.initial,
    this.session,
    this.failure,
    this.signedOut = false,
  });

  final ViewStatus status;
  final AuthSession? session;
  final Failure? failure;

  /// True once the session has been cleared.
  final bool signedOut;

  @override
  List<Object?> get props => [status, session, failure, signedOut];
}

/// Drives the account screen.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._getSession, this._signOut) : super(const AccountState());

  final GetSessionUseCase _getSession;
  final SignOutUseCase _signOut;

  Future<void> load() async {
    emit(const AccountState(status: ViewStatus.loading));
    final result = await _getSession(const NoParams());
    emit(
      result.when(
        success: (session) =>
            AccountState(status: ViewStatus.success, session: session),
        error: (failure) =>
            AccountState(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  /// Clears the session; [AccountState.signedOut] flips on success.
  Future<void> signOut() async {
    final result = await _signOut(const NoParams());
    emit(
      result.when(
        success: (_) => AccountState(
          status: ViewStatus.success,
          session: state.session,
          signedOut: true,
        ),
        error: (failure) => AccountState(
          status: ViewStatus.success,
          session: state.session,
          failure: failure,
        ),
      ),
    );
  }
}
