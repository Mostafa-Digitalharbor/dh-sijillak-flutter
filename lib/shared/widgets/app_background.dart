import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/layout/responsive.dart';
import '../../core/theme/app_colors.dart';

/// A blurred colour blob drawn behind screen content. Offsets are physical
/// (left/right), matching the design; [top] is a design offset that scales
/// with the screen height.
class BackgroundBlob {
  const BackgroundBlob({
    required this.size,
    required this.color,
    required this.opacity,
    this.top,
    this.left,
    this.right,
  });

  final double size;
  final Color color;
  final double opacity;
  final double? top;
  final double? left;
  final double? right;
}

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.blobs = const [],
    this.bottomBar,
  });

  static const double _blobBlur = 70;

  final Widget child;
  final List<BackgroundBlob> blobs;

  /// Pinned to the bottom of the screen (e.g. the primary CTA).
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          for (final b in blobs)
            Positioned(
              top: b.top == null ? null : context.scaledY(b.top!),
              left: b.left,
              right: b.right,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: _blobBlur,
                    sigmaY: _blobBlur,
                  ),
                  child: Container(
                    width: b.size,
                    height: b.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: b.color.withValues(alpha: b.opacity),
                    ),
                  ),
                ),
              ),
            ),
          Positioned.fill(child: child),
          if (bottomBar != null && MediaQuery.viewInsetsOf(context).bottom == 0)
            Positioned(left: 0, right: 0, bottom: 0, child: bottomBar!),
        ],
      ),
    );
  }
}
