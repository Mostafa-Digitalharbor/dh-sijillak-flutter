import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Brand-tinted shadows. Use the presets; build a custom one with [tinted].
abstract final class AppShadows {
  static List<BoxShadow> tinted({
    required double alpha,
    required double blur,
    required double dy,
    Color color = AppColors.primary,
  }) => [
    BoxShadow(
      color: color.withValues(alpha: alpha),
      blurRadius: blur,
      offset: Offset(0, dy),
    ),
  ];

  /// Header panels and glass cards.
  static final card = tinted(alpha: 0.08, blur: 30, dy: 10);

  /// White header slab (welcome / login).
  static final slab = tinted(alpha: 0.06, blur: 30, dy: 10);

  /// Raised document / sheet.
  static final document = tinted(alpha: 0.1, blur: 34, dy: 14);

  /// Primary call-to-action button.
  static final cta = tinted(alpha: 0.28, blur: 22, dy: 10);

  /// Floating bottom navigation bar.
  static final nav = tinted(alpha: 0.14, blur: 30, dy: 12);

  /// Floating "create" button inside the navigation bar.
  static final fab = tinted(alpha: 0.35, blur: 18, dy: 8);

  /// Frosted bar pinned over scrolling content.
  static final bar = tinted(alpha: 0.08, blur: 24, dy: -8);

  /// Selected segment / chip.
  static final chip = tinted(alpha: 0.1, blur: 8, dy: 2);
}
