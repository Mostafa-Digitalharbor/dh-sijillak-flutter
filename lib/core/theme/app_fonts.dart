import 'package:flutter/material.dart';

/// Bundled Tajawal font (declared in pubspec.yaml).
///
/// The design is HTML, where an unstyled line box is
/// `round(size * usWinAscent) + round(size * usWinDescent)` (the browser
/// rounds both to the device grid). The font files in `assets/fonts` carry
/// those win metrics in their hhea/typo tables, and [tajawal] sets the same
/// rounded line height explicitly so every `Text` occupies the same height as
/// its HTML counterpart.
abstract final class AppFonts {
  static const family = 'Tajawal';

  // usWinAscent / usWinDescent per unitsPerEm (1000).
  static const _regular = (1.016, 0.375);
  static const _bold = (1.065, 0.411);

  static double _grid(double v) => (v * 2).round() / 2;

  /// Line-box height the browser gives text of [size] and [weight].
  static double lineBox(double size, FontWeight? weight) {
    final m = (weight?.value ?? 400) >= 600 ? _bold : _regular;
    return _grid(size * m.$1) + _grid(size * m.$2);
  }

  static TextStyle tajawal({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) => TextStyle(
    fontFamily: family,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height:
        height ??
        (fontSize == null ? null : lineBox(fontSize, fontWeight) / fontSize),
    leadingDistribution: TextLeadingDistribution.even,
  );
}

extension TajawalRestyle on TextStyle {
  /// Like `copyWith`, but re-derives the browser line height when the size or
  /// weight changes so the text box keeps matching the design.
  TextStyle restyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    final size = fontSize ?? this.fontSize;
    final weight = fontWeight ?? this.fontWeight;
    return copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height:
          height ??
          (size == null ? this.height : AppFonts.lineBox(size, weight) / size),
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
}
