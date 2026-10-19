import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// Coloured tile (circle by default) showing [text], usually `initialsOf(name)`.
class InitialsBadge extends StatelessWidget {
  const InitialsBadge({
    super.key,
    required this.text,
    this.size = 44,
    this.radius,
    this.background = AppColors.primary,
    this.foreground = Colors.white,
    this.fontSize = 16,
  });

  final String text;
  final double size;

  /// Corner radius; defaults to a circle.
  final double? radius;
  final Color background;
  final Color foreground;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius == null ? null : BorderRadius.circular(radius!),
      ),
      child: Text(
        text,
        style: AppFonts.tajawal(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: foreground,
        ),
      ),
    );
  }
}
