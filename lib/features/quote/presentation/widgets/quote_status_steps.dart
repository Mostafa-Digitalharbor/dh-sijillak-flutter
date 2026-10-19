import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/quote_dimens.dart';
import 'quote_step.dart';

/// Draft -> sent -> confirmed progress tracker of a quote.
class QuoteStatusSteps extends StatelessWidget {
  const QuoteStatusSteps({super.key, required this.confirmed});

  /// Whether the customer's approval has been confirmed.
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    final current = confirmed ? 2 : 1;
    final names = [
      context.l10n.draft,
      context.l10n.quoteSent,
      context.l10n.quoteConfirmed,
    ];
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s14,
      ),
      radius: AppRadius.r20,
      fill: AppColors.white74,
      shadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < names.length; i++) ...[
            QuoteStep(
              name: names[i],
              number: context.digits('${i + 1}'),
              past: i < current || confirmed && i == 2,
              current: i == current && !confirmed,
            ),
            if (i < names.length - 1)
              Expanded(
                child: Container(
                  height: QuoteDimens.stepLineHeight,
                  margin: const EdgeInsets.only(top: QuoteDimens.stepLineTop),
                  color: i < current ? AppColors.primary : AppColors.border,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
