import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';
import '../cubit/otp_cubit.dart';

/// "Resend in m:ss" countdown that turns into a "Resend code" link.
class OtpResendLine extends StatelessWidget {
  const OtpResendLine({super.key, required this.secondsLeft});

  final int secondsLeft;

  static const _secondsPerMinute = 60;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (secondsLeft == 0) {
      return GestureDetector(
        onTap: context.read<OtpCubit>().resend,
        child: Text(
          l10n.resendCode,
          style: AppTextStyles.link.restyle(fontSize: AuthDimens.otpResendFont),
        ),
      );
    }
    final m = secondsLeft ~/ _secondsPerMinute;
    final s = (secondsLeft % _secondsPerMinute).toString().padLeft(2, '0');
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        style: AppTextStyles.subtitle.restyle(
          fontSize: AuthDimens.otpResendFont,
          color: AppColors.textSubtle,
        ),
        children: [
          TextSpan(text: l10n.resendIn),
          TextSpan(
            text: context.digits('$m:$s'),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
