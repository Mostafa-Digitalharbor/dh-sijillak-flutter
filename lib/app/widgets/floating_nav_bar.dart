import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import 'nav_create_button.dart';
import 'nav_item.dart';

/// Frosted bar floating above the bottom edge: two tabs, the create button,
/// two tabs. [tabs] holds the four destinations in display order.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.tabs, required this.location});

  static const double _innerPadding = 6;

  final List<NavTab> tabs;
  final String location;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Positioned(
      left: AppSizes.navMargin,
      right: AppSizes.navMargin,
      // The design floats the bar above the bottom edge; the gesture area
      // (<= 24) is simply drawn over.
      bottom:
          AppSizes.navFloat +
          (bottomInset > AppSpacing.s24 ? bottomInset - AppSpacing.s24 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.bar, sigmaY: AppBlur.bar),
          child: Container(
            height: AppSizes.navHeight,
            padding: const EdgeInsets.symmetric(horizontal: _innerPadding),
            decoration: BoxDecoration(
              color: AppColors.white82,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: AppShadows.nav,
            ),
            child: LayoutBuilder(
              builder: (context, box) {
                // Items shrink on narrow screens so five slots always fit.
                final itemWidth = ((box.maxWidth - AppSizes.navCreateSize) / 4)
                    .clamp(0.0, AppSizes.navItemWidth);
                NavItem item(int i) => NavItem(
                  tab: tabs[i],
                  active: location == tabs[i].path,
                  width: itemWidth,
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    item(0),
                    item(1),
                    const NavCreateButton(),
                    item(2),
                    item(3),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
