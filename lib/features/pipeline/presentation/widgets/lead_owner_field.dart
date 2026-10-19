import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';
import 'lead_field_box.dart';

/// Read-only owner of the new deal (the signed-in user).
class LeadOwnerField extends StatelessWidget {
  const LeadOwnerField({super.key});

  @override
  Widget build(BuildContext context) {
    final owner = context.select(
      (NewLeadCubit c) => c.state.defaults!.owner.name,
    );
    return LabeledField(
      label: context.l10n.owner,
      child: LeadFieldBox(
        child: Row(
          children: [
            InitialsBadge(
              text: initialsOf(owner, maxLetters: 1),
              size: PipelineDimens.pickerBadge,
              background: AppColors.tint,
              foreground: AppColors.primary,
              fontSize: PipelineDimens.ownerBadgeFormFont,
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Text(
                context.l10n.me,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
