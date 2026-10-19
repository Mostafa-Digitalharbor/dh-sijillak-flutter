import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the account screen.
abstract final class AccountDimens {
  static const double topPadding = 56;
  static const double bottomPadding = AppSpacing.s40;

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

  // Profile card
  static const double avatarSize = 60;
  static const double avatarFont = 22;
  static const double nameFont = 19;
  static const double emailFont = 14;

  // Language card
  static const double languageIconBox = 38;
  static const double languageIconSize = 18;
  static const double languageTitleFont = 16;

  // Sign-out dialog
  static const double dialogMaxWidth = 420;
  static const double dialogPadding = AppSpacing.s22;
  static const double dialogTitleFont = 20;
  static const double dialogBodyFont = 15;
  static const double dialogBodyHeight = 1.6;
  static const double dialogBorder = AppSizes.borderThin;
}
