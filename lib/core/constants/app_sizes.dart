/// Fixed dimensions shared across screens.
abstract final class AppSizes {
  /// The artboard the design was drawn on.
  static const double designWidth = 390;
  static const double designHeight = 844;

  /// Widest the app content grows on tablets / landscape; the rest is margin.
  static const double maxContentWidth = 560;

  /// Largest system font scale the layouts are built to absorb.
  static const double maxTextScale = 1.3;

  // Controls
  static const double backButton = 46;
  static const double iconButton = 44;
  static const double buttonHeight = 56;
  static const double compactButtonHeight = 52;
  static const double fieldHeight = 50;
  static const double compactFieldHeight = 48;

  /// Space reserved under scrolling content for a pinned bottom action bar
  /// (button + paddings).
  static const double bottomBarClearance = 130;

  // Floating bottom navigation
  static const double navHeight = 72;
  static const double navItemWidth = 60;
  static const double navItemHeight = 56;
  static const double navCreateSize = 54;
  static const double navMargin = 12;
  static const double navFloat = 16;

  /// Space scrolling content leaves under the floating navigation bar.
  static const double navClearance = 120;

  // Icons
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 22;

  // Strokes
  static const double borderThin = 1;
  static const double borderMedium = 1.5;
  static const double borderThick = 2;
}

/// Gaussian blur sigmas of the frosted-glass surfaces.
abstract final class AppBlur {
  static const double card = 18;
  static const double bar = 20;
  static const double blob = 70;
  static const double backdrop = 3;
}
