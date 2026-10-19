import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../constants/quote_dimens.dart';

/// One circle + caption of the quote progress tracker.
class QuoteStep extends StatelessWidget {
  const QuoteStep({
    super.key,
    required this.name,
    required this.number,
    required this.past,
    required this.current,
  });

  final String name;

  /// Already-localised step number shown while the step is not done.
  final String number;
  final bool past;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: QuoteDimens.stepWidth,
      child: Column(
        children: [
          Container(
            width: QuoteDimens.stepCircle,
            height: QuoteDimens.stepCircle,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: past
                  ? AppColors.primary
                  : (current ? AppColors.accent : AppColors.switchOff),
              shape: BoxShape.circle,
              border: Border.all(
                color: current ? AppColors.stepRing : Colors.transparent,
                width: AppSizes.borderThick,
              ),
            ),
            child: past
                ? const AppIcon(
                    AppIcons.check,
                    size: QuoteDimens.stepCheckSize,
                    color: Colors.white,
                    strokeWidth: QuoteDimens.stepCheckStroke,
                  )
                : Text(
                    number,
                    style: AppFonts.tajawal(
                      fontSize: QuoteDimens.stepNumberSize,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.tajawal(
              fontSize: QuoteDimens.stepLabelSize,
              fontWeight: FontWeight.w700,
              color: past || current ? AppColors.ink : AppColors.navInactive,
            ),
          ),
        ],
      ),
    );
  }
}
