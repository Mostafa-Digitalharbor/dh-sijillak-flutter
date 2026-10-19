import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';
import '../cubit/company_cubit.dart';
import '../cubit/registration_cubit.dart';

/// "handle | .domain" input with availability feedback underneath.
class WorkspaceHandleField extends StatelessWidget {
  const WorkspaceHandleField({super.key});

  static final _inputPattern = RegExp(
    AppConfig.handlePattern,
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final status = context.select((CompanyCubit c) => c.state.status);
    final borderColor = switch (status) {
      HandleStatus.taken => AppColors.warning,
      HandleStatus.available => AppColors.accent,
      HandleStatus.empty ||
      HandleStatus.checking ||
      HandleStatus.unknown => AppColors.border,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.workspaceLink, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.s6),
        Container(
          height: AuthDimens.handleFieldHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r14),
            border: Border.all(
              color: borderColor,
              width: AuthDimens.handleFieldBorder,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      final company = context.read<CompanyCubit>()
                        ..handleChanged(value);
                      context.read<RegistrationCubit>().edit(
                        (d) => d.copyWith(handle: company.state.handle),
                      );
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(_inputPattern),
                    ],
                    style: AppFonts.tajawal(
                      fontSize: AuthDimens.handleFontSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                    decoration: InputDecoration(
                      hintText: AppConfig.sampleHandle,
                      hintStyle: AppFonts.tajawal(
                        fontSize: AuthDimens.handleFontSize,
                        color: AppColors.placeholder,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s12,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                  ),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.tintSoft,
                    border: Border(
                      left: BorderSide(color: AppColors.borderSoft),
                    ),
                  ),
                  child: Text(
                    '.${AppConfig.workspaceDomain}',
                    style: AppTextStyles.subtitle.restyle(
                      color: AppColors.textSubtle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        switch (status) {
          HandleStatus.available => Row(
            children: [
              const AppIcon(
                AppIcons.check,
                size: AuthDimens.handleHintIcon,
                color: AppColors.primary,
                strokeWidth: 2.4,
              ),
              const SizedBox(width: AppSpacing.s6),
              Expanded(
                child: Text(
                  context.l10n.linkAvailable,
                  style: AppTextStyles.captionBold.restyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          HandleStatus.taken => Text(
            context.l10n.linkTaken,
            style: AppTextStyles.captionBold.restyle(color: AppColors.error),
          ),
          HandleStatus.empty ||
          HandleStatus.checking ||
          HandleStatus.unknown => Text(
            context.l10n.linkRules,
            style: AppTextStyles.subtitle.restyle(
              fontSize: AuthDimens.handleRulesFont,
            ),
          ),
        },
      ],
    );
  }
}
