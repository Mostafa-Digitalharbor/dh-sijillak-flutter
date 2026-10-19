import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_border_box.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/pipeline_cubit.dart';

/// Dashed bar with the summed value of the selected stage.
class StageTotalBar extends StatelessWidget {
  const StageTotalBar({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.select((PipelineCubit c) => c.state.total);
    return DashedBorderBox(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s12,
      ),
      fill: AppColors.white55,
      radius: AppRadius.r16,
      color: AppColors.borderDashed,
      contentBox: true,
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.stageTotal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.subtitle.restyle(
                fontSize: PipelineDimens.totalLabelFont,
                color: AppColors.textStrong,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            context.l10n.amountSar(context.amount(total)),
            maxLines: 1,
            style: AppTextStyles.title.restyle(
              fontSize: PipelineDimens.totalValueFont,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
