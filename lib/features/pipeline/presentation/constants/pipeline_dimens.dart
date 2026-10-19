import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Layout numbers specific to the deals pipeline and the new-deal form.
abstract final class PipelineDimens {
  /// Design top padding of the pipeline list (status bar included).
  static const double topPadding = 56;

  /// Design top padding of the new-deal form.
  static const double formTopPadding = 52;

  /// Space under the pipeline list so the floating navigation never covers it.
  static const double bottomPadding =
      AppSizes.navHeight +
      AppSizes.navFloat +
      AppSizes.navMargin +
      AppSpacing.s20;

  // Backdrops
  static const pipelineBlobs = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 260,
      right: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 600,
      left: -80,
    ),
  ];

  static const formBlobs = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 220,
      left: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 600,
      right: -80,
    ),
  ];

  // Header buttons
  static const double headerIconSize = AppSizes.iconLg;
  static const double headerAddStroke = 2.2;

  // Stage chips
  static const double chipsListHeight = 44;
  static const double chipsListPadding = 2;
  static const double stageChipHeight = 40;
  static const double formStageChipHeight = 38;
  static const double stageCountFont = 12;
  static const double stageCountHPadding = 7;
  static const double stageCountVPadding = 1;

  // Deal card
  static const double dealTitleFont = 16;
  static const double dealCustomerFont = 13;
  static const double dealValueFont = 17;
  static const double dealProgressHeight = 6;
  static const double dealNextActionFont = 13;
  static const double ownerBadge = 28;
  static const double ownerBadgeFont = 12;

  // Stage total
  static const double totalLabelFont = 14;
  static const double totalValueFont = 16;

  // New-deal form
  static const double formPadding = AppSpacing.s16;
  static const double fieldGap = AppSpacing.s14;
  static const double pickerBadge = 30;
  static const double pickerBadgeRadius = 10;
  static const double pickerBadgeFont = 12;
  static const double ownerBadgeFormFont = 13;
  static const double newCustomerFont = 13;
  static const double notesFont = 15;
  static const double notesVPadding = 12;
  static const double newCustomerMaxWidthFraction = 0.3;
  static const double saveButtonFont = 16;
  static const double saveAndQuoteFont = 15;
  static const double saveAndQuoteExtraWidth = AppSizes.borderMedium * 2;
  static const int notesMinLines = 2;
  static const int notesMaxLines = 4;
}
