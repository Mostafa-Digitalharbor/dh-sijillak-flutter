import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/customer_dimens.dart';

/// One timeline entry: a ringed dot joined by a line to the next entry.
class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.dot,
    required this.ring,
    required this.title,
    required this.subtitle,
    this.last = false,
  });

  final Color dot;
  final Color ring;
  final String title;
  final String subtitle;

  /// The final entry has no connecting line and no bottom spacing.
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: CustomerDimens.dotSize,
                height: CustomerDimens.dotSize,
                margin: const EdgeInsets.only(top: CustomerDimens.dotTopOffset),
                decoration: BoxDecoration(
                  color: dot,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ring,
                    width: CustomerDimens.dotRing,
                  ),
                ),
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: CustomerDimens.lineWidth,
                    color: AppColors.borderButton,
                  ),
                ),
            ],
          ),
          const SizedBox(width: CustomerDimens.timelineGap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: last ? 0 : CustomerDimens.itemSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyBold),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    subtitle,
                    style: AppTextStyles.subtitle.restyle(
                      fontSize: CustomerDimens.subtitleFont,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
