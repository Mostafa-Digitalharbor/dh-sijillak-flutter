import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/notifications_repository.dart';

/// Marks every notification as read.
class MarkAllNotificationsReadUseCase implements UseCase<void, NoParams> {
  const MarkAllNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.markAllRead();
}
