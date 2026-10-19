import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../cubit/new_lead_cubit.dart';

/// Side-by-side expected value and expected close date inputs.
class LeadValueAndDate extends StatelessWidget {
  const LeadValueAndDate({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewLeadCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppTextField(
            label: context.l10n.expectedValue,
            controller: cubit.valueController,
            hint: context.l10n.newLeadValueHint,
            keyboardType: TextInputType.number,
            height: AppSizes.compactFieldHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: AppTextField(
            label: context.l10n.expectedClose,
            controller: cubit.expectedCloseController,
            hint: context.l10n.expectedCloseHint,
            height: AppSizes.compactFieldHeight,
          ),
        ),
      ],
    );
  }
}
