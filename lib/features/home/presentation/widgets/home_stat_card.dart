import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/home_dimens.dart';

/// Tappable frosted card with a label, a headline value and a coloured note.
class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.noteColor,
    required this.onTap,
    this.unit,
  });

  final String label;
  final String value;

  /// Currency shown after [value], when the value is an amount.
  final String? unit;
  final String note;
  final Color noteColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.s14),
        radius: AppRadius.r20,
        fill: AppColors.white72,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.subtitle.restyle(
                  fontSize: HomeDimens.statLabelFont,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Text.rich(
                TextSpan(
                  text: value,
                  style: AppTextStyles.title.restyle(
                    fontSize: HomeDimens.statValueFont,
                  ),
                  children: [
                    if (unit != null)
                      TextSpan(
                        text: ' $unit',
                        style: AppTextStyles.subtitle.restyle(
                          fontSize: HomeDimens.statUnitFont,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(
                note,
                style: AppTextStyles.caption.restyle(
                  fontWeight: FontWeight.w700,
                  color: noteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
