import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the notifications screen.
abstract final class NotificationsDimens {
  /// Design top padding of the header (before the status-bar inset).
  static const double topPadding = 52;
  static const double bottomPadding = 34;

  static const double rowIconTile = 44;
  static const double rowIconSize = 20;
  static const double unreadDot = 9;

  /// The "mark all as read" action never grows beyond this, even with large
  /// text, so the header title keeps room.
  static const double markAllMaxWidth = 140;
  static const double markAllFontSize = 14;
  static const double groupHeadingSize = 14;

  static const double emptyIconTile = 72;
  static const double emptyIconSize = 32;

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
