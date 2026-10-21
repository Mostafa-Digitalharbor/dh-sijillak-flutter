import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/screen_header.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';
import '../widgets/customer_picker.dart';
import '../widgets/lead_notes_field.dart';
import '../widgets/lead_owner_field.dart';
import '../widgets/lead_stage_picker.dart';
import '../widgets/lead_value_and_date.dart';
import '../widgets/new_lead_bottom_bar.dart';

/// Form for creating a deal, for [customerId] when given (otherwise the
/// customer can be chosen in the form).
class NewLeadScreen extends StatelessWidget {
  const NewLeadScreen({super.key, this.customerId});

  final String? customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewLeadCubit>()..load(customerId),
      child: const _NewLeadView(),
    );
  }
}

class _NewLeadView extends StatelessWidget {
  const _NewLeadView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewLeadCubit>();
    final state = context.select((NewLeadCubit c) => c.state);
    return AppBackground(
      blobs: PipelineDimens.formBlobs,
      bottomBar: const NewLeadBottomBar(),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            context.topPad(PipelineDimens.formTopPadding),
            AppSpacing.gutter,
            AppSizes.bottomBarClearance,
          ),
          child: Column(
            children: [
              ScreenHeader(title: context.l10n.newDeal, close: true),
              const SizedBox(height: AppSpacing.s14),
              GlassCard(
                padding: const EdgeInsets.all(PipelineDimens.formPadding),
                fill: AppColors.white74,
                child: StatusBody(
                  status: state.status,
                  failure: state.failure,
                  onRetry: cubit.load,
                  builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: context.l10n.dealTitle,
                        hint: context.l10n.dealTitleHint,
                        controller: cubit.titleController,
                        height: AppSizes.compactFieldHeight,
                      ),
                      const SizedBox(height: PipelineDimens.fieldGap),
                      const CustomerPicker(),
                      const SizedBox(height: PipelineDimens.fieldGap),
                      const LeadValueAndDate(),
                      const SizedBox(height: PipelineDimens.fieldGap),
                      const LeadStagePicker(),
                      const SizedBox(height: PipelineDimens.fieldGap),
                      const LeadOwnerField(),
                      const SizedBox(height: PipelineDimens.fieldGap),
                      const LeadNotesField(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
