import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import 'lead_input_parser.dart';

/// Reads the typed expected-close date using the active locale's month names.
extension LeadDates on BuildContext {
  static const _monthKeys = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec',
  ];

  /// The date written in [text], or null when it is empty or unreadable.
  DateTime? parseExpectedClose(String text, {required DateTime now}) =>
      LeadInputParser.date(
        text,
        now: now,
        monthNames: {
          for (var i = 0; i < _monthKeys.length; i++)
            l10n.monthName(_monthKeys[i]).toLowerCase(): i + 1,
        },
      );
}
