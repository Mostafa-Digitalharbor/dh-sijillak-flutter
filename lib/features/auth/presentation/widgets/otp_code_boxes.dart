import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../constants/auth_rules.dart';
import 'otp_digit_box.dart';

/// The row of verification-code cells (always left-to-right).
class OtpCodeBoxes extends StatelessWidget {
  const OtpCodeBoxes({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.verificationCode,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            for (var i = 0; i < AuthRules.otpLength; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: OtpDigitBox(
                  digit: i < code.length ? code[i] : '',
                  active: i == code.length,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
