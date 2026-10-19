import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/business_sector.dart';

/// Display names of the business sectors.
extension BusinessSectorL10n on BusinessSector {
  String localized(AppLocalizations l10n) => switch (this) {
    BusinessSector.trade => l10n.sectorTrade,
    BusinessSector.industry => l10n.sectorIndustry,
    BusinessSector.services => l10n.sectorServices,
    BusinessSector.contracting => l10n.sectorContracting,
    BusinessSector.other => l10n.sectorOther,
  };
}
