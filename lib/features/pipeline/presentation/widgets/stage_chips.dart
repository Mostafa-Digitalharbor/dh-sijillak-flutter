import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/deal_stage.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/pipeline_cubit.dart';
import '../extensions/deal_stage_l10n.dart';
import 'stage_chip.dart';

/// Horizontally scrolling strip of stage chips with their deal counts.
class StageChips extends StatelessWidget {
  const StageChips({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select((PipelineCubit c) => c.state.stage);
    final pipeline = context.select((PipelineCubit c) => c.state.pipeline!);
    return SizedBox(
      height: PipelineDimens.chipsListHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          vertical: PipelineDimens.chipsListPadding,
        ),
        itemCount: DealStage.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s8),
        itemBuilder: (context, i) {
          final stage = DealStage.values[i];
          return StageChip(
            label: stage.localized(context),
            selected: stage == selected,
            count: context.digits('${pipeline.summaryOf(stage).count}'),
            height: PipelineDimens.stageChipHeight,
            idleFill: AppColors.white72,
            idleBorder: AppColors.glassBorder,
            onTap: () => context.read<PipelineCubit>().selectStage(stage),
          );
        },
      ),
    );
  }
}
