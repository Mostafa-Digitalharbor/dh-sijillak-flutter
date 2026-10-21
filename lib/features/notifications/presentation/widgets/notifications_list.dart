import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_group.dart';
import '../constants/notifications_dimens.dart';
import '../cubit/notifications_cubit.dart';
import '../extensions/notification_navigation.dart';
import 'notification_group_heading.dart';
import 'notification_row.dart';
import 'notifications_empty_state.dart';

/// The notifications grouped by day, or the empty state.
class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key, required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) return const NotificationsEmptyState();
    final now = DateTime.now();
    final cubit = context.read<NotificationsCubit>();
    return ListView(
      padding: EdgeInsets.only(
        top: AppSpacing.s16,
        bottom: context.bottomPad(NotificationsDimens.bottomPadding),
      ),
      children: [
        for (final group in NotificationGroup.byDay(
          notifications,
          now: now,
        )) ...[
          NotificationGroupHeading(bucket: group.bucket),
          const SizedBox(height: AppSpacing.s10),
          for (final notification in group.items) ...[
            NotificationRow(
              notification: notification,
              now: now,
              onTap: () {
                cubit.markRead(notification.id);
                context.openNotificationTarget(notification);
              },
            ),
            const SizedBox(height: AppSpacing.s10),
          ],
          const SizedBox(height: AppSpacing.s8),
        ],
      ],
    );
  }
}
