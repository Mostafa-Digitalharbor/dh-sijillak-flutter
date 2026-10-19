import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

/// Frosted white card with a soft brand shadow.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s18),
    this.radius = AppRadius.r22,
    this.fill = AppColors.glassFill,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color fill;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadow ? AppShadows.card : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.card, sigmaY: AppBlur.card),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: borderRadius,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
