import 'package:flutter/material.dart';

/// A rounded box with a CSS-style dashed border (dash 3x, gap 2x the stroke
/// width, as Chromium draws thin dashed borders), drawn inside the box.
class DashedBorderBox extends StatelessWidget {
  const DashedBorderBox({
    super.key,
    required this.color,
    required this.radius,
    this.strokeWidth = 1,
    this.fill,
    this.padding,
    this.width,
    this.height,
    this.contentBox = false,
    this.child,
  });

  /// Dash and gap length as multiples of the stroke width.
  static const double dashFactor = 3;
  static const double gapFactor = 2;

  /// CSS `box-sizing: content-box`: the border (and padding) grow the box
  /// instead of eating into it.
  final bool contentBox;

  final Color color;
  final double radius;
  final double strokeWidth;
  final Color? fill;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final grow = contentBox ? strokeWidth : 0.0;
    return Container(
      width: width == null ? null : width! + grow * 2,
      height: height == null ? null : height! + grow * 2,
      padding: (padding ?? EdgeInsets.zero).add(EdgeInsets.all(grow)),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
      ),
      foregroundDecoration: _DashedDecoration(color, radius, strokeWidth),
      child: child,
    );
  }
}

class _DashedDecoration extends Decoration {
  const _DashedDecoration(this.color, this.radius, this.strokeWidth);

  final Color color;
  final double radius;
  final double strokeWidth;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _DashedPainter(color, radius, strokeWidth);
}

class _DashedPainter extends BoxPainter {
  _DashedPainter(this.color, this.radius, this.strokeWidth);

  final Color color;
  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final rect = (offset & size).deflate(strokeWidth / 2);
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(radius - strokeWidth / 2),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final dash = strokeWidth * DashedBorderBox.dashFactor;
    final gap = strokeWidth * DashedBorderBox.gapFactor;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }
}
