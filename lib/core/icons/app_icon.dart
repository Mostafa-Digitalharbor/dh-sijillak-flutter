import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders one of [AppIcons] exactly as the design draws it: a 24x24 viewBox
/// scaled to [size], round-capped strokes of [strokeWidth] in [color].
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.svg, {
    super.key,
    required this.size,
    required this.color,
    this.strokeWidth = defaultStroke,
    this.filled = false,
    this.semanticLabel,
  });

  /// Stroke width the design uses unless an icon says otherwise.
  static const double defaultStroke = 1.8;

  /// Inner SVG markup (see `AppIcons`).
  final String svg;
  final double size;
  final Color color;
  final double strokeWidth;

  /// Fill the shapes instead of stroking them (e.g. the "more" dots).
  final bool filled;
  final String? semanticLabel;

  static String _hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  @override
  Widget build(BuildContext context) {
    final c = _hex(color);
    final attrs = filled
        ? 'fill="$c"'
        : 'fill="none" stroke="$c" stroke-width="$strokeWidth" '
              'stroke-linecap="round" stroke-linejoin="round"';
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" $attrs>$svg</svg>',
      width: size,
      height: size,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}

/// The invoice QR sample, drawn from the design's 21x21 module grid.
class AppQrSample extends StatelessWidget {
  const AppQrSample({
    super.key,
    required this.size,
    required this.svg,
    required this.color,
  });

  final double size;
  final String svg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 21 21" shape-rendering="crispEdges">'
      '<g fill="${AppIcon._hex(color)}">$svg</g></svg>',
      width: size,
      height: size,
    );
  }
}
