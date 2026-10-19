import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// One destination of the bottom navigation bar.
class NavTab {
  const NavTab(this.path, this.label, this.icon, {this.push = false});

  final String path;
  final String label;

  /// Inner SVG markup from `AppIcons`.
  final String icon;

  /// Opens above the shell (full screen) instead of switching tabs.
  final bool push;
}

/// Icon + label button of the bottom navigation bar.
class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.tab,
    required this.active,
    required this.width,
  });

  static const double _inactiveStroke = AppIcon.defaultStroke;
  static const double _activeStroke = AppSizes.borderThick;

  final NavTab tab;
  final bool active;
  final double width;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.navInactive;
    return Semantics(
      selected: active,
      button: true,
      label: tab.label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        onTap: () => tab.push ? context.push(tab.path) : context.go(tab.path),
        child: SizedBox(
          width: width,
          height: AppSizes.navItemHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                tab.icon,
                size: AppSizes.iconLg,
                color: color,
                strokeWidth: active ? _activeStroke : _inactiveStroke,
              ),
              const SizedBox(height: AppSpacing.s3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tab.label,
                  maxLines: 1,
                  style: AppFonts.tajawal(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
