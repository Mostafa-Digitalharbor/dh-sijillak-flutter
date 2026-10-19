import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the home dashboard.
abstract final class HomeDimens {
  /// Design top padding of the scrolling content (status bar included).
  static const double topPadding = 56;

  /// Space under the content so the floating navigation never covers it.
  static const double bottomPadding =
      AppSizes.navHeight +
      AppSizes.navFloat +
      AppSizes.navMargin +
      AppSpacing.s20;

  // Backdrop
  static const blobs = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.25,
      top: 60,
      left: -110,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 470,
      right: -80,
    ),
  ];

  // Header
  static const double avatarSize = AppSizes.backButton;
  static const double avatarFont = 18;
  static const double greetingFont = 14;
  static const double userNameFont = 19;
  static const double bellDot = 9;
  static const double bellDotTop = 10;
  static const double bellDotRight = 11;

  // Search field
  static const double searchHeight = AppSizes.fieldHeight;

  // Sales card
  static const double salesGlowSize = 180;
  static const double salesGlowTop = -70;
  static const double salesGlowLeft = -50;
  static const double salesGlowBlur = 20;
  static const double salesGlowAlpha = 0.45;
  static const double salesAmountFont = 34;
  static const double salesCurrencyFont = 16;
  static const double salesBarsHeight = 46;
  static const double salesBarRadius = 6;
  static final salesShadow = AppShadows.tinted(alpha: 0.3, blur: 30, dy: 14);

  // Stat cards
  static const double statLabelFont = 13;
  static const double statValueFont = 22;
  static const double statUnitFont = 13;

  // Quick actions
  static const double quickActionBox = 54;
  static const double quickActionIcon = 24;

  // Tasks
  static const double tasksTitleFont = 18;
  static const double taskIconBox = 38;
  static const double taskIconSize = 18;
  static const double taskSubtitleFont = 13;
}
