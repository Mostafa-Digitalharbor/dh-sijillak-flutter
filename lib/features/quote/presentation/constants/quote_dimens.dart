import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the quote screen.
abstract final class QuoteDimens {
  /// Design top offset of the header (before the status-bar inset).
  static const double topPadding = 52;

  static const double stepWidth = 64;
  static const double stepCircle = 32;
  static const double stepLineHeight = 2;

  /// Distance from the top of a step to its connector line.
  static const double stepLineTop = 17;
  static const double stepLabelSize = 12;
  static const double stepNumberSize = 13;
  static const double stepCheckSize = 16;
  static const double stepCheckStroke = 2.4;
  static const double bannerIconSize = 18;
  static const double badgeSize = 42;
  static const double badgeFontSize = 15;
  static const double actionTileHeight = 54;
  static const double actionIconSize = 18;
  static const double actionLabelSize = 12;
  static const double actionButtonHeight = 54;
  static const double actionButtonRadius = 16;
  static const double actionButtonFont = 16;

  static const blobs = [
    BackgroundBlob(
      size: 320,
      color: AppColors.accent,
      opacity: 0.24,
      top: 40,
      right: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 560,
      left: -80,
    ),
  ];
}
