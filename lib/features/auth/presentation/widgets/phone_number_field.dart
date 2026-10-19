import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../constants/auth_dimens.dart';

/// Mobile number input with the country-code box beside it.
class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.mobileNumber, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.s6),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                hint: l10n.authPhoneHint,
                keyboardType: TextInputType.phone,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Container(
              height: AuthDimens.phoneFieldHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.tintSoft,
                borderRadius: BorderRadius.circular(AppRadius.r14),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                l10n.authPhoneCountryCode,
                style: AppTextStyles.bodyBold.restyle(
                  color: AppColors.textStrong,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
