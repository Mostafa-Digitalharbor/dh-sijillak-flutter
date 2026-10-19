import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

/// Frosted bar pinned to the bottom of a screen, holding the primary actions.
class GlassBottomBar extends StatelessWidget {
  const GlassBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.bar, sigmaY: AppBlur.bar),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.s14,
            AppSpacing.gutter,
            AppSpacing.s30,
          ),
          decoration: BoxDecoration(
            color: AppColors.white85,
            border: const Border(top: BorderSide(color: AppColors.glassBorder)),
            boxShadow: AppShadows.bar,
          ),
          child: child,
        ),
      ),
    );
  }
}
