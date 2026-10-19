import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/icons/app_icons.dart';
import '../../core/l10n/l10n.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

/// The raised "+" button in the middle of the bottom navigation bar.
class NavCreateButton extends StatelessWidget {
  const NavCreateButton({super.key});

  static const double _iconSize = 26;
  static const double _iconStroke = 2.2;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r18);
    return Semantics(
      button: true,
      label: context.l10n.createNew,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: shape,
          boxShadow: AppShadows.fab,
        ),
        child: Material(
          color: AppColors.primary,
          borderRadius: shape,
          child: InkWell(
            borderRadius: shape,
            onTap: () => context.push(AppRoutes.newInvoice),
            child: const SizedBox(
              width: AppSizes.navCreateSize,
              height: AppSizes.navCreateSize,
              child: Center(
                child: AppIcon(
                  AppIcons.plus,
                  size: _iconSize,
                  color: Colors.white,
                  strokeWidth: _iconStroke,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
