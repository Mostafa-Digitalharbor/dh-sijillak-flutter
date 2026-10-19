import 'package:flutter/material.dart';

import '../../core/constants/app_durations.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_shadows.dart';

/// Equal-width pill tab strip (invoice status, customer sections).
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  static const double _tabHeight = 38;

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.white60,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.s4),
            Expanded(
              child: Semantics(
                selected: i == selected,
                button: true,
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: AppDurations.quick,
                    height: _tabHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      boxShadow: i == selected ? AppShadows.chip : null,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        labels[i],
                        maxLines: 1,
                        style: AppFonts.tajawal(
                          fontSize: 14,
                          fontWeight: i == selected
                              ? FontWeight.w800
                              : FontWeight.w700,
                          color: i == selected
                              ? AppColors.primary
                              : AppColors.textSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
