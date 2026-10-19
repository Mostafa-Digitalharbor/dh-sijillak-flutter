import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';

/// One cell of the verification code; [active] marks the next one to fill.
class OtpDigitBox extends StatelessWidget {
  const OtpDigitBox({super.key, required this.digit, required this.active});

  final String digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 56 + the 2px active border on both sides (cells stretch).
      height: AuthDimens.otpBoxHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? Colors.white : AppColors.white78,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        border: Border.all(
          color: active ? AppColors.accent : AppColors.border,
          width: active ? AuthDimens.otpBoxActiveBorder : 1,
        ),
      ),
      child: Text(
        context.digits(digit),
        style: AppTextStyles.title.restyle(fontSize: AuthDimens.otpBoxFont),
      ),
    );
  }
}
