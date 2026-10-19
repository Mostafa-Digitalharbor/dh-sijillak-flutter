import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';

/// An amount in the active locale's numerals followed by the currency, each
/// with its own style (the currency is usually smaller and lighter).
class CurrencyAmount extends StatelessWidget {
  const CurrencyAmount({
    super.key,
    required this.amount,
    required this.amountStyle,
    required this.currencyStyle,
  });

  final num amount;
  final TextStyle amountStyle;
  final TextStyle currencyStyle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: context.amount(amount),
        style: amountStyle,
        children: [
          TextSpan(text: context.l10n.sarSpaced, style: currencyStyle),
        ],
      ),
    );
  }
}
