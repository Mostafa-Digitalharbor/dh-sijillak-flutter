import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_config.dart';
import '../../domain/usecases/check_workspace_handle_use_case.dart';
import '../constants/auth_rules.dart';

/// Where the typed workspace handle stands.
enum HandleStatus { empty, checking, available, taken, unknown }

/// The workspace handle typed so far and whether it can be claimed.
class CompanyState extends Equatable {
  const CompanyState({this.handle = '', this.status = HandleStatus.empty});

  final String handle;
  final HandleStatus status;

  /// The handle shown in the link preview (a sample until one is typed).
  String get previewHandle => handle.isEmpty ? AppConfig.sampleHandle : handle;

  @override
  List<Object?> get props => [handle, status];
}

/// Holds the workspace handle of registration step 1 and checks, after a
/// short pause in typing, that nobody owns it yet.
class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(this._checkHandle, {this.debounce = AuthRules.handleDebounce})
    : super(const CompanyState());

  static final _allowed = RegExp(AppConfig.handlePattern);

  final CheckWorkspaceHandleUseCase _checkHandle;

  /// Quiet time after typing before the availability check runs.
  final Duration debounce;
  Timer? _timer;

  void handleChanged(String value) {
    final cleaned = _allowed
        .allMatches(value.toLowerCase())
        .map((m) => m[0])
        .join();
    if (cleaned == state.handle) return;
    _timer?.cancel();
    if (cleaned.isEmpty) {
      emit(const CompanyState());
      return;
    }
    emit(CompanyState(handle: cleaned, status: HandleStatus.checking));
    _timer = Timer(debounce, () => _verify(cleaned));
  }

  Future<void> _verify(String handle) async {
    final result = await _checkHandle(handle);
    // A newer keystroke supersedes this answer.
    if (isClosed || state.handle != handle) return;
    emit(
      CompanyState(
        handle: handle,
        status: result.when(
          success: (free) => free ? HandleStatus.available : HandleStatus.taken,
          error: (_) => HandleStatus.unknown,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
