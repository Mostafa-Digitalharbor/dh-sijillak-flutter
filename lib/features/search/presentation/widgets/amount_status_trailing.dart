import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/currency_amount.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../constants/search_dimens.dart';

/// Trailing side of a result row: an amount over a status pill.
class AmountStatusTrailing extends StatelessWidget {
  const AmountStatusTrailing({
    super.key,
    required this.amount,
    required this.status,
    required this.background,
    required this.foreground,
  });

  final num amount;
  final String status;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CurrencyAmount(
          amount: amount,
          amountStyle: AppTextStyles.bodyBold.restyle(
            fontWeight: FontWeight.w800,
          ),
          currencyStyle: AppTextStyles.caption.restyle(
            fontSize: SearchDimens.currencySize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        StatusPill(
          text: status,
          background: background,
          foreground: foreground,
        ),
      ],
    );
  }
}
