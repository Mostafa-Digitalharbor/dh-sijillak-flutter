import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/registration_draft.dart';
import '../../domain/entities/workspace.dart';
import '../../domain/usecases/register_workspace_use_case.dart';

/// The data collected so far and the state of the final submission.
class RegistrationState extends Equatable {
  const RegistrationState({
    this.draft = const RegistrationDraft(),
    this.status = ViewStatus.initial,
    this.failure,
    this.workspace,
  });

  final RegistrationDraft draft;
  final ViewStatus status;
  final Failure? failure;

  /// The workspace created by the submission.
  final Workspace? workspace;

  RegistrationState withDraft(RegistrationDraft draft) => RegistrationState(
    draft: draft,
    status: status,
    failure: failure,
    workspace: workspace,
  );

  @override
  List<Object?> get props => [draft, status, failure, workspace];
}

/// Shared by every registration route: each step writes into the draft and
/// the last one submits it.
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit(this._register) : super(const RegistrationState());

  final RegisterWorkspaceUseCase _register;

  /// Applies [change] to the draft.
  void edit(RegistrationDraft Function(RegistrationDraft draft) change) =>
      emit(state.withDraft(change(state.draft)));

  /// Drops what the tax step collected (the user chose to do it later).
  void skipTax() => edit((d) => d.withoutTaxDetails());

  /// Creates the workspace from the draft.
  Future<void> submit() async {
    if (state.status.isLoading) return;
    emit(RegistrationState(draft: state.draft, status: ViewStatus.loading));
    final result = await _register(state.draft);
    if (isClosed) return;
    emit(
      RegistrationState(
        draft: state.draft,
        status: result.isSuccess ? ViewStatus.success : ViewStatus.failure,
        failure: result.failureOrNull,
        workspace: result.dataOrNull,
      ),
    );
  }
}
