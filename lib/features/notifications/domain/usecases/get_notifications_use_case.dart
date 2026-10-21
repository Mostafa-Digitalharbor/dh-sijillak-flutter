import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

/// Loads every notification.
class GetNotificationsUseCase
    implements UseCase<List<AppNotification>, NoParams> {
  const GetNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<List<AppNotification>>> call(NoParams params) =>
      _repository.getNotifications();
}
