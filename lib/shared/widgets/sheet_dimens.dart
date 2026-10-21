import '../../core/theme/app_shadows.dart';

/// Geometry of the frosted bottom sheets (`showFrostedSheet`).
abstract final class SheetDimens {
  static const double radius = 30;
  static const double blur = 24;
  static const double handleWidth = 44;
  static const double handleHeight = 5;
  static const double titleSize = 22;
  static const double tileMinHeight = 52;
  static const double tileTitleSize = 15;

  /// Gap kept between the top of the screen and a tall sheet.
  static const double topMargin = 24;
  static final shadow = AppShadows.tinted(alpha: 0.18, blur: 40, dy: -12);
}
