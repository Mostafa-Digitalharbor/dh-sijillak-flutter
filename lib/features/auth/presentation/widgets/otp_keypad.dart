import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../constants/auth_dimens.dart';
import '../constants/auth_rules.dart';
import '../cubit/otp_cubit.dart';

/// Numeric keypad (1-9, 0 and delete) feeding the [OtpCubit].
class OtpKeypad extends StatelessWidget {
  const OtpKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var r = 0; r < AuthRules.keypadRows.length; r++) ...[
          if (r > 0) const SizedBox(height: AuthDimens.keyGap),
          SizedBox(
            height: AuthDimens.keyHeight,
            child: Row(
              children: [
                for (var c = 0; c < AuthRules.keypadRows[r].length; c++) ...[
                  if (c > 0) const SizedBox(width: AuthDimens.keyGap),
                  Expanded(
                    child: _KeypadSlot(keyValue: AuthRules.keypadRows[r][c]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _KeypadSlot extends StatelessWidget {
  const _KeypadSlot({required this.keyValue});

  final String keyValue;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();
    return switch (keyValue) {
      AuthRules.keypadBlank => const SizedBox.shrink(),
      AuthRules.keypadDelete => _OtpKey(
        semanticLabel: context.l10n.delete,
        filled: false,
        onTap: cubit.deletePressed,
        glyph: AuthRules.backspaceGlyph,
      ),
      _ => _OtpKey(
        semanticLabel: context.digits(keyValue),
        onTap: () => cubit.digitPressed(keyValue),
        glyph: context.digits(keyValue),
      ),
    };
  }
}

class _OtpKey extends StatelessWidget {
  const _OtpKey({
    required this.glyph,
    required this.onTap,
    required this.semanticLabel,
    this.filled = true,
  });

  final String glyph;
  final VoidCallback onTap;
  final String semanticLabel;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: filled ? AppColors.white75 : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r14),
          onTap: onTap,
          child: Center(
            child: Text(
              glyph,
              style: AppFonts.tajawal(
                fontSize: AuthDimens.keyFont,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
