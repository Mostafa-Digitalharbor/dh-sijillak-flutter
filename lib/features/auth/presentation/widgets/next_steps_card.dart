import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/auth_dimens.dart';
import 'next_step_row.dart';

/// "Start in three steps" checklist shown once the workspace exists.
class NextStepsCard extends StatelessWidget {
  const NextStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AuthDimens.nextStepsPadX,
        vertical: AuthDimens.nextStepsPadY,
      ),
      fill: AppColors.white74,
      shadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AuthDimens.nextStepsHeadingTop,
              bottom: AuthDimens.nextStepsHeadingBottom,
            ),
            child: Text(
              l10n.startInThreeSteps,
              style: AppTextStyles.label.restyle(fontWeight: FontWeight.w800),
            ),
          ),
          NextStepRow(
            number: context.digits('1'),
            text: l10n.addFirstCustomer,
            showDivider: true,
          ),
          NextStepRow(
            number: context.digits('2'),
            text: l10n.addProducts,
            showDivider: true,
          ),
          NextStepRow(
            number: context.digits('3'),
            text: l10n.issueFirstInvoice,
          ),
        ],
      ),
    );
  }
}
