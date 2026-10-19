import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import 'quote_action_tile.dart';

/// WhatsApp / email / download shortcuts under the quote.
class QuoteShareRow extends StatelessWidget {
  const QuoteShareRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: QuoteActionTile(icon: AppIcons.message, label: l10n.whatsapp),
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: QuoteActionTile(icon: AppIcons.mail, label: l10n.mail),
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: QuoteActionTile(icon: AppIcons.download, label: l10n.download),
        ),
      ],
    );
  }
}
