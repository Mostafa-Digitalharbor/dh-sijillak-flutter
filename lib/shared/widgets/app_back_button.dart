import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/icons/app_icons.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';

/// Leading back button of every pushed screen.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r14);
    return Semantics(
      button: true,
      label: context.l10n.back,
      excludeSemantics: true,
      child: Material(
        color: AppColors.white72,
        shape: RoundedRectangleBorder(
          borderRadius: shape,
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          borderRadius: shape,
          onTap: () {
            if (context.canPop()) context.pop();
          },
          child: const SizedBox(
            width: AppSizes.backButton,
            height: AppSizes.backButton,
            child: Center(
              child: AppIcon(
                AppIcons.chevronRight,
                size: AppSizes.iconMd,
                color: AppColors.ink,
                strokeWidth: AppSizes.borderThick,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
