import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../constants/auth_dimens.dart';
import '../constants/auth_rules.dart';
import '../cubit/account_cubit.dart';
import '../cubit/registration_cubit.dart';

/// Password input with the three-bar strength meter underneath.
class PasswordStrengthField extends StatelessWidget {
  const PasswordStrengthField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<AccountCubit>().state;
    final onColor = switch (state.strength) {
      PasswordStrength.strong => AppColors.accent,
      PasswordStrength.medium => AppColors.amber,
      _ => AppColors.warning,
    };
    final label = switch (state.strength) {
      PasswordStrength.none => '',
      PasswordStrength.weak => l10n.strengthWeak,
      PasswordStrength.medium => l10n.strengthMedium,
      PasswordStrength.strong => l10n.strengthStrong,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: l10n.password,
          hint: l10n.passwordHint,
          obscureText: true,
          onChanged: (value) {
            context.read<AccountCubit>().passwordChanged(value);
            context.read<RegistrationCubit>().edit(
              (d) => d.copyWith(password: value),
            );
          },
        ),
        const SizedBox(height: AppSpacing.s6),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  for (var i = 1; i <= AuthRules.strengthBars; i++) ...[
                    if (i > 1) const SizedBox(width: AppSpacing.s4),
                    Expanded(
                      child: Container(
                        height: AuthDimens.strengthBarHeight,
                        decoration: BoxDecoration(
                          color: i <= state.filledBars
                              ? onColor
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Text(
              label,
              style: AppTextStyles.caption.restyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textStrong,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
