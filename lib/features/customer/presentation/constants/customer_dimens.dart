import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the customer profile.
abstract final class CustomerDimens {
  /// Design top padding of the scrolling content (status bar included).
  static const double topPadding = 52;

  static const blobs = [
    BackgroundBlob(
      size: 320,
      color: AppColors.accent,
      opacity: 0.25,
      top: -40,
      right: -90,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 520,
      left: -90,
    ),
  ];

  // Top bar
  static const double barTitleFont = 16;

  // Profile card
  static const double badgeSize = 60;
  static const double badgeRadius = 20;
  static const double badgeFont = 22;
  static const double nameFont = 19;
  static const double locationFont = 14;
  static const double vatFont = 13;
  static const double contactHeight = 62;
  static const double contactIcon = AppSizes.iconMd;

  // Stat tiles
  static const double statValueFont = 17;

  // Timeline
  static const double timelineIndent = 6;
  static const double dotSize = 18;
  static const double dotRing = 3;
  static const double dotTopOffset = 4;
  static const double lineWidth = 2;
  static const double timelineGap = 14;
  static const double itemSpacing = 16;
  static const double subtitleFont = 13;

  // Customers list
  static const double listTopPadding = 56;
  static const double listSubtitleFont = 14;
  static const double searchFieldHeight = 48;
  static const double searchFieldFont = 15;
  static const double rowBadgeSize = 46;
  static const double rowBadgeFont = 16;
  static const double rowIconTile = 42;
  static const double rowIconSize = 20;
  static const double rowCurrencySize = 11;
  static const double emptyTopSpace = 40;

  /// Relative widths of the text block and the trailing figure of a row.
  static const int rowTextFlex = 3;
  static const int rowTrailingFlex = 2;
}
