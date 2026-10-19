import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';
import '../extensions/deal_stage_l10n.dart';
import 'stage_chip.dart';

/// Wrapping row of the stages a new deal can start in.
class LeadStagePicker extends StatelessWidget {
  const LeadStagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select((NewLeadCubit c) => c.state.stage);
    return LabeledField(
      label: context.l10n.stage,
      gap: AppSpacing.s8,
      child: Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        children: [
          for (final stage in NewLeadCubit.selectableStages)
            StageChip(
              label: stage.localized(context),
              selected: stage == selected,
              height: PipelineDimens.formStageChipHeight,
              idleFill: Colors.white,
              idleBorder: AppColors.border,
              onTap: () => context.read<NewLeadCubit>().selectStage(stage),
            ),
        ],
      ),
    );
  }
}
