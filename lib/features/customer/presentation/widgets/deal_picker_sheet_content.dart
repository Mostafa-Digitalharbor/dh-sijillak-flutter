import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/frosted_sheet_body.dart';
import '../../../../shared/widgets/sheet_action_tile.dart';
import '../../../../shared/widgets/status_body.dart';
import '../cubit/deal_picker_cubit.dart';
import '../models/deal_picker_choice.dart';
import 'deal_pick_tile.dart';

/// Content of the deal picker sheet: the "new deal" entry and the customer's
/// open deals. Pops a `DealPickerChoice`.
class DealPickerSheetContent extends StatelessWidget {
  const DealPickerSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<DealPickerCubit>();
    final state = context.watch<DealPickerCubit>().state;
    return FrostedSheetBody(
      title: l10n.dealPickerTitle,
      children: [
        SheetActionTile(
          label: l10n.dealPickerNew,
          onTap: () => Navigator.of(context).pop(const NewDealChoice()),
        ),
        const SizedBox(height: AppSpacing.s10),
        StatusBody(
          status: state.status,
          failure: state.failure,
          onRetry: cubit.load,
          builder: (_) => state.deals.isEmpty
              ? Text(
                  l10n.dealPickerEmpty,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                )
              : Column(
                  children: [
                    for (final deal in state.deals) ...[
                      DealPickTile(
                        deal: deal,
                        onTap: () =>
                            Navigator.of(context).pop(ExistingDealChoice(deal)),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}
