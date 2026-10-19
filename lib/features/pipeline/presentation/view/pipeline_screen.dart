import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/pipeline_cubit.dart';
import '../widgets/deal_card.dart';
import '../widgets/pipeline_header.dart';
import '../widgets/stage_chips.dart';
import '../widgets/reload_on_return.dart';
import '../widgets/stage_total_bar.dart';

/// Deals grouped by stage: stage selector, stage total and the deal cards.
class PipelineScreen extends StatelessWidget {
  const PipelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PipelineCubit>()..load(),
      child: const _PipelineView(),
    );
  }
}

class _PipelineView extends StatelessWidget {
  const _PipelineView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PipelineCubit>();
    final state = context.select((PipelineCubit c) => c.state);
    return ReloadOnReturn(
      path: AppRoutes.pipeline,
      onReturn: () => cubit.load(silent: true),
      child: AppBackground(
        blobs: PipelineDimens.pipelineBlobs,
        child: SafeArea(
          top: false,
          bottom: false,
          child: StatusBody(
            status: state.status,
            failure: state.failure,
            onRetry: context.read<PipelineCubit>().load,
            builder: (context) => ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                context.topPad(PipelineDimens.topPadding),
                AppSpacing.gutter,
                PipelineDimens.bottomPadding,
              ),
              children: [
                const PipelineHeader(),
                const SizedBox(height: AppSpacing.s16),
                const StageChips(),
                const SizedBox(height: AppSpacing.s16),
                const StageTotalBar(),
                const SizedBox(height: AppSpacing.s16),
                for (final deal in state.deals) ...[
                  DealCard(deal: deal),
                  const SizedBox(height: AppSpacing.s12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
