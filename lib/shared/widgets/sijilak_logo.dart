import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/l10n.dart';

/// The brand logo cropped to its content, as laid out in the design
/// (the source image has wide padding around the mark). Never wider than the
/// space it is given.
class SijilakLogo extends StatelessWidget {
  const SijilakLogo({super.key, this.width = _cropWidth});

  /// Preferred width; shrinks to fit narrower parents.
  final double width;

  // The visible crop of the source image, and where it sits in it.
  static const double _cropWidth = 286;
  static const double _cropHeight = 110;
  static const double _imageWidth = 366;
  static const double _imageLeft = -41;
  static const double _imageTop = -63;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final logoWidth = math.max(0.0, math.min(width, box.maxWidth));
        final scale = logoWidth / _cropWidth;
        return Semantics(
          label: context.l10n.appName,
          image: true,
          child: SizedBox(
            width: logoWidth,
            height: _cropHeight * scale,
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned(
                    left: _imageLeft * scale,
                    top: _imageTop * scale,
                    width: _imageWidth * scale,
                    child: Image.asset(AppAssets.logo, fit: BoxFit.fitWidth),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
