import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_icon_button.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/pipeline_cubit.dart';

/// Screen title with the open-deals summary and the add / search / filter
/// buttons.
class PipelineHeader extends StatelessWidget {
  const PipelineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final pipeline = context.select((PipelineCubit c) => c.state.pipeline!);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.navPipeline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title,
              ),
              Text(
                context.l10n.pipelineSummary(
                  context.digits('${pipeline.openDeals}'),
                  context.amount(pipeline.expectedValue),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle.restyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GlassIconButton(
          icon: AppIcons.plus,
          iconSize: PipelineDimens.headerIconSize,
          strokeWidth: PipelineDimens.headerAddStroke,
          label: context.l10n.newDeal,
          filled: true,
          onPressed: () => context.push(AppRoutes.newLead),
        ),
        const SizedBox(width: AppSpacing.s10),
        GlassIconButton(
          icon: AppIcons.search,
          label: context.l10n.search,
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.s10),
        GlassIconButton(
          icon: AppIcons.tune,
          label: context.l10n.filter,
          onPressed: () {},
        ),
      ],
    );
  }
}
