import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/app_notification.dart';

/// Opens the screen a notification is about.
extension NotificationNavigation on BuildContext {
  /// Pushes the quote, invoice, deal board or customer of [notification]
  /// (in that order of precedence); does nothing when it has no target.
  void openNotificationTarget(AppNotification notification) {
    if (notification.quoteNumber != null) {
      push(AppRoutes.quote, extra: notification.quoteNumber);
    } else if (notification.invoiceNumber != null) {
      push(AppRoutes.invoice, extra: notification.invoiceNumber);
    } else if (notification.dealId != null) {
      push(AppRoutes.pipeline);
    } else if (notification.customerId != null) {
      push(AppRoutes.customer, extra: notification.customerId);
    }
  }
}
