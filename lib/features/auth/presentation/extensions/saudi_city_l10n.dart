import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/saudi_city.dart';

/// Display names of the cities.
extension SaudiCityL10n on SaudiCity {
  String localized(AppLocalizations l10n) => switch (this) {
    SaudiCity.riyadh => l10n.cityRiyadh,
    SaudiCity.jeddah => l10n.cityJeddah,
    SaudiCity.dammam => l10n.cityDammam,
    SaudiCity.makkah => l10n.cityMakkah,
    SaudiCity.madinah => l10n.cityMadinah,
  };
}
