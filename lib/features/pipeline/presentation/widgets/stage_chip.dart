import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/pipeline_dimens.dart';

/// Pill that selects a deal stage, optionally with the number of deals in it.
class StageChip extends StatelessWidget {
  const StageChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.height,
    required this.idleFill,
    required this.idleBorder,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double height;

  /// Background and border while not selected.
  final Color idleFill;
  final Color idleBorder;

  /// Already-formatted deal count shown in a small badge.
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : idleFill,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: selected ? null : Border.all(color: idleBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.label.restyle(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textStrong,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: AppSpacing.s6),
                _CountBadge(count: count!, selected: selected),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.selected});

  final String count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PipelineDimens.stageCountHPadding,
        vertical: PipelineDimens.stageCountVPadding,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.white20 : AppColors.borderSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        count,
        style: AppTextStyles.caption.restyle(
          color: selected ? Colors.white : AppColors.textStrong,
        ),
      ),
    );
  }
}
