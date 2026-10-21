import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_unread_count_use_case.dart';

/// Number of unread notifications, shown as the dot on the home bell. A
/// failed refresh keeps the last known count: the bell is decoration, not a
/// place to report errors.
class UnreadCountCubit extends Cubit<int> {
  UnreadCountCubit(this._getUnreadCount) : super(0);

  final GetUnreadCountUseCase _getUnreadCount;

  Future<void> load() async {
    final result = await _getUnreadCount(const NoParams());
    if (isClosed) return;
    final count = result.dataOrNull;
    if (count != null) emit(count);
  }
}
