import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/icons/app_icon.dart';
import '../../core/theme/app_fonts.dart';

/// Small rounded status label with an optional leading icon.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 9,
      vertical: AppSpacing.s2,
    ),
    this.icon,
  });

  static const double _iconSize = 15;
  static const double _iconStroke = 2.2;

  final String text;
  final Color background;
  final Color foreground;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  /// Optional leading icon (inner SVG markup from `AppIcons`).
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppIcon(
              icon!,
              size: _iconSize,
              color: foreground,
              strokeWidth: _iconStroke,
            ),
            const SizedBox(width: AppSpacing.s5),
          ],
          Text(
            text,
            style: AppFonts.tajawal(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
