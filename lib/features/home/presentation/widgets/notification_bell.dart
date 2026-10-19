import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../constants/home_dimens.dart';

/// Round bell button with the unread-notifications dot.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.notifications,
      excludeSemantics: true,
      child: Material(
        color: AppColors.white70,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: SizedBox(
            width: AppSizes.backButton,
            height: AppSizes.backButton,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const AppIcon(
                  AppIcons.bell,
                  size: AppSizes.iconLg,
                  color: AppColors.ink,
                ),
                Positioned(
                  top: HomeDimens.bellDotTop,
                  right: HomeDimens.bellDotRight,
                  child: Container(
                    width: HomeDimens.bellDot,
                    height: HomeDimens.bellDot,
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: AppSizes.borderThick,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
