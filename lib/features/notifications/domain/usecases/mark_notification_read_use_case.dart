import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

/// Marks one notification, by id, as read.
class MarkNotificationReadUseCase implements UseCase<AppNotification, String> {
  const MarkNotificationReadUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<AppNotification>> call(String id) => _repository.markRead(id);
}
