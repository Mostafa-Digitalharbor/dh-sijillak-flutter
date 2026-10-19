import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/home_dimens.dart';
import '../cubit/home_cubit.dart';
import 'task_row.dart';

/// "Today's tasks" section: a title with a "view all" link above the list.
class TodayTasks extends StatelessWidget {
  const TodayTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((HomeCubit c) => c.state.overview!.tasks);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.todaysTasks,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title.restyle(
                  fontSize: HomeDimens.tasksTitleFont,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Text(
                context.l10n.viewAll,
                maxLines: 1,
                style: AppTextStyles.link,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s10),
        GlassCard(
          padding: EdgeInsets.zero,
          radius: AppRadius.r20,
          fill: AppColors.white72,
          shadow: false,
          child: Column(
            children: [
              for (var i = 0; i < tasks.length; i++)
                TaskRow(task: tasks[i], divider: i < tasks.length - 1),
            ],
          ),
        ),
      ],
    );
  }
}
