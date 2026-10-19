import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';

/// Multi-line free-text notes input of the new-deal form.
class LeadNotesField extends StatelessWidget {
  const LeadNotesField({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.subtitle.restyle(
      fontSize: PipelineDimens.notesFont,
    );
    return LabeledField(
      label: context.l10n.notes,
      child: TextField(
        controller: context.read<NewLeadCubit>().notesController,
        minLines: PipelineDimens.notesMinLines,
        maxLines: PipelineDimens.notesMaxLines,
        style: textStyle.restyle(color: AppColors.ink),
        decoration: InputDecoration(
          hintText: context.l10n.notesHint,
          hintStyle: textStyle.restyle(color: AppColors.placeholder),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical: PipelineDimens.notesVPadding,
          ),
          enabledBorder: _border(AppColors.border),
          focusedBorder: _border(AppColors.accent, AppSizes.borderMedium),
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r14),
        borderSide: BorderSide(color: color, width: width),
      );
}
