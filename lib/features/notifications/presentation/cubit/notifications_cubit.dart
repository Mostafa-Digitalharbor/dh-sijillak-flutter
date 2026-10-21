import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/mark_all_notifications_read_use_case.dart';
import '../../domain/usecases/mark_notification_read_use_case.dart';

/// The notifications list, its load status and the last failed action.
class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = ViewStatus.initial,
    this.notifications = const [],
    this.failure,
    this.actionFailure,
  });

  final ViewStatus status;
  final List<AppNotification> notifications;

  /// Why the list could not load.
  final Failure? failure;

  /// Why the last mark-as-read could not be saved (the list is rolled back).
  final Failure? actionFailure;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    Failure? actionFailure,
  }) => NotificationsState(
    status: status,
    notifications: notifications ?? this.notifications,
    failure: failure,
    actionFailure: actionFailure,
  );

  @override
  List<Object?> get props => [status, notifications, failure, actionFailure];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._getNotifications, this._markRead, this._markAllRead)
    : super(const NotificationsState());

  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationReadUseCase _markRead;
  final MarkAllNotificationsReadUseCase _markAllRead;

  Future<void> load() async {
    emit(NotificationsState(status: ViewStatus.loading));
    final result = await _getNotifications(const NoParams());
    if (isClosed) return;
    emit(
      result.when(
        success: (items) => NotificationsState(
          status: ViewStatus.success,
          notifications: items,
        ),
        error: (failure) =>
            NotificationsState(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  /// Marks [id] as read right away and saves it; rolls back when saving fails.
  Future<void> markRead(String id) async {
    final before = state.notifications;
    final target = before.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;
    emit(
      state.copyWith(
        notifications: [
          for (final n in before) n.id == id ? n.markedRead() : n,
        ],
      ),
    );
    final result = await _markRead(id);
    if (isClosed) return;
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(notifications: before, actionFailure: failure));
    }
  }

  /// Marks every notification as read; rolls back when saving fails.
  Future<void> markAllRead() async {
    final before = state.notifications;
    if (state.unreadCount == 0) return;
    emit(
      state.copyWith(notifications: [for (final n in before) n.markedRead()]),
    );
    final result = await _markAllRead(const NoParams());
    if (isClosed) return;
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(notifications: before, actionFailure: failure));
    }
  }
}
