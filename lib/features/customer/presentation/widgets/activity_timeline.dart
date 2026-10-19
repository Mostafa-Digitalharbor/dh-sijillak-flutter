import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/customer_activity.dart';
import '../constants/customer_dimens.dart';
import '../extensions/activity_text.dart';
import '../cubit/customer_cubit.dart';
import 'timeline_item.dart';

/// Vertical timeline of the customer's recent activity.
class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final activity = context.select(
      (CustomerCubit c) => c.state.customer!.activity,
    );
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: CustomerDimens.timelineIndent,
      ),
      child: Column(
        children: [
          for (var i = 0; i < activity.length; i++)
            TimelineItem(
              dot: _dotColor(activity[i].kind),
              ring: _ringColor(activity[i].kind),
              title: activity[i].title,
              subtitle: context.activitySubtitle(activity[i], now: now),
              last: i == activity.length - 1,
            ),
        ],
      ),
    );
  }

  static Color _dotColor(CustomerActivityKind kind) => switch (kind) {
    CustomerActivityKind.quoteSent => AppColors.accent,
    CustomerActivityKind.call => AppColors.primary,
    CustomerActivityKind.invoiceOverdue => AppColors.warning,
  };

  static Color _ringColor(CustomerActivityKind kind) => switch (kind) {
    CustomerActivityKind.invoiceOverdue => AppColors.ringWarm,
    _ => AppColors.ringTeal,
  };
}
