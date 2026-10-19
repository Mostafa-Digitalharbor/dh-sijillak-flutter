import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The design is drawn at 390x844 with its own top/bottom paddings baked in
/// (it assumes a status bar of roughly that height). These keep the design's
/// padding when the device bars are smaller, and grow it only when the real
/// status bar / gesture area would otherwise overlap the content.
extension ScreenInsets on BuildContext {
  double topPad(double design) =>
      math.max(design, MediaQuery.paddingOf(this).top + 4);

  double bottomPad(double design) =>
      math.max(design, MediaQuery.paddingOf(this).bottom);
}
