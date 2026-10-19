import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/view_status.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/glass_bottom_bar.dart';
import '../../../../shared/widgets/grow_row.dart';
import '../../../../shared/widgets/outline_action_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';
import '../extensions/lead_dates.dart';

/// Pinned "save" and "save & create quote" actions of the new-deal form.
class NewLeadBottomBar extends StatelessWidget {
  const NewLeadBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canSubmit = context.select((NewLeadCubit c) => c.state.canSubmit);
    return BlocListener<NewLeadCubit, NewLeadState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: _onSubmitted,
      child: GlassBottomBar(
        child: GrowRow(
          items: [
            GrowItem(
              label: l10n.saveDeal,
              fontSize: PipelineDimens.saveButtonFont,
              child: PrimaryButton(
                label: l10n.saveDeal,
                height: AppSizes.compactButtonHeight,
                radius: AppRadius.r16,
                fontSize: PipelineDimens.saveButtonFont,
                enabled: canSubmit,
                onPressed: () => _save(context, createQuote: false),
              ),
            ),
            GrowItem(
              label: l10n.saveAndCreateQuote,
              fontSize: PipelineDimens.saveAndQuoteFont,
              extraWidth: PipelineDimens.saveAndQuoteExtraWidth,
              child: OutlineActionButton(
                label: l10n.saveAndCreateQuote,
                fontSize: PipelineDimens.saveAndQuoteFont,
                onPressed: canSubmit
                    ? () => _save(context, createQuote: true)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _save(BuildContext context, {required bool createQuote}) {
    final cubit = context.read<NewLeadCubit>();
    cubit.submit(
      expectedClose: context.parseExpectedClose(
        cubit.expectedCloseController.text,
        now: DateTime.now(),
      ),
      createQuote: createQuote,
    );
  }

  static void _onSubmitted(BuildContext context, NewLeadState state) {
    switch (state.submitStatus) {
      case ViewStatus.success:
        final quoteNumber = state.quoteNumber;
        if (state.createQuote && quoteNumber != null) {
          context.pushReplacement(AppRoutes.quote, extra: quoteNumber);
        } else {
          context.pop();
        }
      case ViewStatus.failure:
        showFailureSnackBar(context, state.submitFailure!);
      case ViewStatus.initial:
      case ViewStatus.loading:
        break;
    }
  }
}
