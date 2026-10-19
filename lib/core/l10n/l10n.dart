import 'package:flutter/widgets.dart';

import '../../l10n/gen/app_localizations.dart';
import '../utils/arabic_digits.dart';

export '../../l10n/gen/app_localizations.dart';

extension AppL10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  /// [value] with the numerals of the active locale (Arabic-Indic for `ar`).
  String digits(String value) => isArabic ? value.toArabicDigits : value;

  /// Rounded, grouped amount in the numerals of the active locale.
  String amount(num value) =>
      isArabic ? value.toArabicAmount : value.toLatinAmount;
}
