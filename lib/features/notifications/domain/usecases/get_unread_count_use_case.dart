import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/notifications_repository.dart';

/// Counts the notifications the user has not opened yet.
class GetUnreadCountUseCase implements UseCase<int, NoParams> {
  const GetUnreadCountUseCase(this._repository);

  final NotificationsRepository _repository;

  @override
  Future<Result<int>> call(NoParams params) => _repository.getUnreadCount();
}
