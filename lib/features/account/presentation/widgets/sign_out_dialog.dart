import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/danger_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../constants/account_dimens.dart';

/// Asks the user to confirm signing out; resolves `true` when confirmed.
Future<bool> confirmSignOut(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.scrim,
    builder: (_) => const SignOutDialog(),
  );
  return confirmed ?? false;
}

/// Frosted, rounded confirmation dialog in the style of the payment sheet.
class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shape = BorderRadius.circular(AppRadius.r28);
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(AppSpacing.gutter),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AccountDimens.dialogMaxWidth,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: shape,
            boxShadow: AppShadows.document,
          ),
          child: ClipRRect(
            borderRadius: shape,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppBlur.card,
                sigmaY: AppBlur.card,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white94,
                  borderRadius: shape,
                  border: Border.all(
                    color: AppColors.glassBorder,
                    width: AccountDimens.dialogBorder,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AccountDimens.dialogPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.settingsSignOutTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title.restyle(
                          fontSize: AccountDimens.dialogTitleFont,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        l10n.settingsSignOutBody,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle.restyle(
                          fontSize: AccountDimens.dialogBodyFont,
                          height: AccountDimens.dialogBodyHeight,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s20),
                      DangerButton(
                        label: l10n.settingsSignOutConfirm,
                        filled: true,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      const SizedBox(height: AppSpacing.s10),
                      SecondaryButton(
                        label: l10n.settingsCancel,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
