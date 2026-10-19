import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../constants/auth_dimens.dart';
import '../cubit/registration_cubit.dart';

/// "I agree to the terms and the privacy policy" checkbox row.
class TermsCheckboxRow extends StatelessWidget {
  const TermsCheckboxRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accepted = context.select(
      (RegistrationCubit c) => c.state.draft.termsAccepted,
    );
    void setAccepted(bool value) => context.read<RegistrationCubit>().edit(
      (d) => d.copyWith(termsAccepted: value),
    );
    final base = AppFonts.tajawal(
      fontSize: AuthDimens.termsFont,
      color: AppColors.textStrong,
    );
    final link = base.restyle(
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.primary,
    );
    return InkWell(
      onTap: () => setAccepted(!accepted),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AuthDimens.checkboxSize,
            height: AuthDimens.checkboxSize,
            child: Checkbox(
              value: accepted,
              activeColor: AppColors.primary,
              onChanged: (v) => setAccepted(v ?? false),
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AuthDimens.termsTextTopPad),
              child: Text.rich(
                TextSpan(
                  style: base,
                  children: [
                    TextSpan(text: l10n.agreeTo),
                    TextSpan(text: l10n.termsOfUse, style: link),
                    TextSpan(text: l10n.andJoiner),
                    TextSpan(text: l10n.privacyPolicy, style: link),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
