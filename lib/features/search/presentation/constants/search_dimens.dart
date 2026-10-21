import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the search screen.
abstract final class SearchDimens {
  /// Design top padding of the header (before the status-bar inset).
  static const double topPadding = 52;
  static const double bottomPadding = 24;

  static const double rowIconTile = 44;
  static const double rowIconSize = 20;
  static const double currencySize = 11;
  static const double recentIconSize = 18;
  static const double headingFont = 14;
  static const double clearFont = 14;
  static const double clearMaxWidth = 120;

  static const double messageIconTile = 72;
  static const double messageIconSize = 32;

  static const blobs = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 100,
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
