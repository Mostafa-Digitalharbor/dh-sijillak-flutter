import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../quote/domain/entities/quote_document.dart';

/// Pill label and colours of a quote's [QuoteStatus] in search results.
extension QuoteHitStatusStyle on QuoteStatus {
  String label(BuildContext context) => switch (this) {
    QuoteStatus.sent => context.l10n.quoteSent,
    QuoteStatus.approved => context.l10n.quoteConfirmed,
  };

  Color get background => switch (this) {
    QuoteStatus.sent => AppColors.dueBg,
    QuoteStatus.approved => AppColors.paidBg,
  };

  Color get foreground => switch (this) {
    QuoteStatus.sent => AppColors.dueFg,
    QuoteStatus.approved => AppColors.primary,
  };
}
