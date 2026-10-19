import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/formatting/calendar_days.dart';
import '../../../../shared/formatting/time_l10n.dart';
import '../../domain/entities/deal.dart';

/// Wording of a deal's "what happens next" line, derived from its dates.
extension DealText on BuildContext {
  static const _tomorrow = 1;
  static const _lastNamedWeekday = 7;

  /// "Site visit — Sunday", "Meeting today 1:00 PM", "Quote expires in 3 days"
  /// and so on, relative to [now].
  String nextStepOf(Deal deal, {required DateTime now}) {
    final action = deal.nextAction;
    if (action != null) {
      final at = action.at;
      if (at == null) return action.title;
      final days = now.calendarDaysUntil(at);
      if (days == 0 && action.hasTime) {
        return l10n.dealNextActionTodayAt(action.title, clockTime(at));
      }
      return l10n.dealNextActionWhen(action.title, _dayLabel(at, days));
    }
    final expires = deal.quoteExpiresAt;
    if (expires != null) {
      final days = now.calendarDaysUntil(expires);
      if (days <= 0) return l10n.dealQuoteExpiresToday;
      if (days == _tomorrow) return l10n.dealQuoteExpiresTomorrow;
      return l10n.dealQuoteExpiresInDays(digits('$days'));
    }
    final close = deal.expectedClose;
    if (close != null) return l10n.dealExpectedCloseOn(shortDate(close));
    return l10n.dealNoNextAction;
  }

  String _dayLabel(DateTime at, int days) {
    if (days == 0) return l10n.relativeToday;
    if (days == _tomorrow) return l10n.relativeTomorrow;
    if (days > _tomorrow && days <= _lastNamedWeekday) return weekdayOf(at);
    return shortDate(at);
  }
}
