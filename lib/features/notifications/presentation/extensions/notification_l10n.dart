import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_day_bucket.dart';
import '../../domain/entities/notification_kind.dart';

/// Localised wording of a notification, composed from its kind and data.
extension NotificationL10n on AppNotification {
  /// Headline of the notification.
  String title(BuildContext context) {
    final l10n = context.l10n;
    final customer = customerName ?? '';
    return switch (kind) {
      NotificationKind.quoteViewed => l10n.notifQuoteViewedTitle(customer),
      NotificationKind.quoteApproved => l10n.notifQuoteApprovedTitle(customer),
      NotificationKind.invoiceOverdue => l10n.notifInvoiceOverdueTitle(
        context.digits('${documentNumber ?? ''}'),
      ),
      NotificationKind.paymentReceived => l10n.notifPaymentReceivedTitle(
        customer,
      ),
      NotificationKind.taskReminder => l10n.notifTaskReminderTitle,
      NotificationKind.dealWon => l10n.notifDealWonTitle(customer),
    };
  }

  /// Detail line under the headline.
  String body(BuildContext context) {
    final l10n = context.l10n;
    final money = _money(context);
    final number = context.digits('${documentNumber ?? ''}');
    return switch (kind) {
      NotificationKind.quoteViewed ||
      NotificationKind.quoteApproved => l10n.notifQuoteBody(number, money),
      NotificationKind.invoiceOverdue => l10n.notifJoinedBody(
        customerName ?? '',
        money,
      ),
      NotificationKind.paymentReceived => l10n.notifPaymentReceivedBody(
        money,
        number,
      ),
      NotificationKind.taskReminder => l10n.notifJoinedBody(
        subject ?? '',
        customerName ?? '',
      ),
      NotificationKind.dealWon => l10n.notifJoinedBody(subject ?? '', money),
    };
  }

  String _money(BuildContext context) =>
      context.l10n.amountSar(context.amount(amount ?? 0));
}

/// Section titles of the day buckets.
extension NotificationDayBucketL10n on NotificationDayBucket {
  String label(BuildContext context) => switch (this) {
    NotificationDayBucket.today => context.l10n.today,
    NotificationDayBucket.yesterday => context.l10n.notifGroupYesterday,
    NotificationDayBucket.earlier => context.l10n.notifGroupEarlier,
  };
}
