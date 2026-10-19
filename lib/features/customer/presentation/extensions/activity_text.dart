import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/formatting/time_l10n.dart';
import '../../domain/entities/customer_activity.dart';

/// Wording of a timeline entry's subtitle, derived from its raw data.
extension ActivityText on BuildContext {
  /// "65,000 SAR · 2 hours ago", "Note · Yesterday", "... · Overdue by 5 days".
  String activitySubtitle(CustomerActivity activity, {required DateTime now}) {
    final when = activity.kind == CustomerActivityKind.invoiceOverdue
        ? overdueSince(activity.at, now: now)
        : relativePast(activity.at, now: now);
    final total = activity.amount;
    final lead =
        activity.detail ??
        (total == null ? null : l10n.amountSar(amount(total)));
    return lead == null ? when : l10n.activityDetailLine(lead, when);
  }
}
