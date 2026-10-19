import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/deal_stage.dart';

extension DealStageL10n on DealStage {
  String localized(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      DealStage.newLead => l10n.stageNew,
      DealStage.qualified => l10n.stageQualified,
      DealStage.quote => l10n.quote,
      DealStage.negotiation => l10n.stageNegotiation,
      DealStage.won => l10n.stageWon,
    };
  }
}
