import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/formatting/time_l10n.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../domain/entities/home_task.dart';
import '../constants/home_dimens.dart';

/// One line of the task list: kind icon, title with customer, and the time.
class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.task, this.divider = false});

  final HomeTask task;

  /// Draw a hairline under the row (all but the last).
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final isCall = task.kind == HomeTaskKind.call;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: AppColors.borderSoft))
            : null,
      ),
      child: Row(
        children: [
          IconTile(
            icon: isCall ? AppIcons.phone : AppIcons.calendar,
            size: HomeDimens.taskIconBox,
            iconSize: HomeDimens.taskIconSize,
            radius: AppRadius.r12,
            background: isCall ? AppColors.tint : AppColors.warmTint,
            foreground: isCall ? AppColors.primary : AppColors.overdue,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyBold,
                ),
                Text(
                  task.customerName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle.restyle(
                    fontSize: HomeDimens.taskSubtitleFont,
                  ),
                ),
              ],
            ),
          ),
          Text(
            context.clockTime(task.scheduledAt),
            style: AppTextStyles.captionBold.restyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
