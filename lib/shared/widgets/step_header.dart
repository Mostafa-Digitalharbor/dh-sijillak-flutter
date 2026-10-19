import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_back_button.dart';

// Temporary re-export while features migrate to importing the button directly.
export 'app_back_button.dart';

/// Back button + "الخطوة n من total" + segmented progress bar + optional action.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.step,
    this.total = 5,
    this.actionLabel,
    this.onAction,
  });

  static const double _barHeight = 5;

  final int step;
  final int total;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.stepOf(
                  context.digits('$step'),
                  context.digits('$total'),
                ),
                style: AppTextStyles.captionBold,
              ),
              const SizedBox(height: AppSpacing.s6),
              Row(
                children: [
                  for (var i = 1; i <= total; i++) ...[
                    if (i > 1) const SizedBox(width: AppSpacing.s4),
                    Expanded(
                      child: Container(
                        height: _barHeight,
                        decoration: BoxDecoration(
                          color: i <= step
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(width: AppSpacing.s12),
          Semantics(
            button: true,
            excludeSemantics: true,
            label: actionLabel,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                child: Text(actionLabel!, style: AppTextStyles.link),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
