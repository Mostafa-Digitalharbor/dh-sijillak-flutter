import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';

/// Screen-size helpers for layouts that scale with the device.
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  /// [designPx] (a vertical offset on the 844px artboard) scaled to this
  /// screen's height.
  double scaledY(double designPx) =>
      designPx * screenHeight / AppSizes.designHeight;
}

/// Wraps the whole app: centres it and caps its width on large screens, and
/// limits how far the system font scale can grow so fixed-height controls
/// never clip their labels.
class ResponsiveFrame extends StatelessWidget {
  const ResponsiveFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = math.min(media.size.width, AppSizes.maxContentWidth);
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: SizedBox(
          width: width,
          child: MediaQuery(
            data: media.copyWith(
              size: Size(width, media.size.height),
              textScaler: media.textScaler.clamp(
                maxScaleFactor: AppSizes.maxTextScale,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
