import 'package:get_it/get_it.dart';

import '../../../core/network/api_client.dart';
import '../data/datasources/notifications_remote_data_source.dart';
import '../data/repositories/notifications_repository_impl.dart';
import '../domain/repositories/notifications_repository.dart';
import '../domain/usecases/get_notifications_use_case.dart';
import '../domain/usecases/get_unread_count_use_case.dart';
import '../domain/usecases/mark_all_notifications_read_use_case.dart';
import '../domain/usecases/mark_notification_read_use_case.dart';
import '../presentation/cubit/notifications_cubit.dart';
import '../presentation/cubit/unread_count_cubit.dart';

export '../data/datasources/notifications_mock_api.dart';

/// Registers the notifications feature's data, domain and presentation
/// dependencies.
void registerNotifications(GetIt getIt) {
  getIt
    ..registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(getIt<ApiClient>()),
    )
    ..registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(getIt<NotificationsRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetNotificationsUseCase(getIt()))
    ..registerLazySingleton(() => GetUnreadCountUseCase(getIt()))
    ..registerLazySingleton(() => MarkNotificationReadUseCase(getIt()))
    ..registerLazySingleton(() => MarkAllNotificationsReadUseCase(getIt()))
    ..registerFactory(() => NotificationsCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => UnreadCountCubit(getIt()));
}
