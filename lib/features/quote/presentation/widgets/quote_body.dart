import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/quote_document.dart';
import 'quote_document_card.dart';
import 'quote_share_row.dart';
import 'quote_status_steps.dart';
import 'quote_viewed_banner.dart';

/// Everything under the quote header: progress, view notice, document, share.
class QuoteBody extends StatelessWidget {
  const QuoteBody({super.key, required this.quote});

  final QuoteDocument quote;

  @override
  Widget build(BuildContext context) {
    final viewedAt = quote.viewedAt;
    final validUntil = quote.validUntil;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuoteStatusSteps(confirmed: quote.isApproved),
        if (!quote.isApproved && viewedAt != null && validUntil != null) ...[
          const SizedBox(height: AppSpacing.s14),
          QuoteViewedBanner(viewedAt: viewedAt, validUntil: validUntil),
        ],
        const SizedBox(height: AppSpacing.s14),
        QuoteDocumentCard(quote: quote),
        const SizedBox(height: AppSpacing.s14),
        const QuoteShareRow(),
      ],
    );
  }
}
