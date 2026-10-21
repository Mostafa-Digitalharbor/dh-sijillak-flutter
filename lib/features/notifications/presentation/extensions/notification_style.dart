import 'dart:ui';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_kind.dart';

/// Icon and tile colours of each [NotificationKind].
extension NotificationKindStyle on NotificationKind {
  String get icon => switch (this) {
    NotificationKind.quoteViewed => AppIcons.eye,
    NotificationKind.quoteApproved => AppIcons.check,
    NotificationKind.invoiceOverdue => AppIcons.clock,
    NotificationKind.paymentReceived => AppIcons.card,
    NotificationKind.taskReminder => AppIcons.calendar,
    NotificationKind.dealWon => AppIcons.gift,
  };

  Color get background => switch (this) {
    NotificationKind.quoteViewed => AppColors.tint,
    NotificationKind.quoteApproved => AppColors.paidBg,
    NotificationKind.invoiceOverdue => AppColors.overdueBg,
    NotificationKind.paymentReceived => AppColors.paidBg,
    NotificationKind.taskReminder => AppColors.dueBg,
    NotificationKind.dealWon => AppColors.warmTint,
  };

  Color get foreground => switch (this) {
    NotificationKind.quoteViewed => AppColors.primary,
    NotificationKind.quoteApproved => AppColors.primary,
    NotificationKind.invoiceOverdue => AppColors.error,
    NotificationKind.paymentReceived => AppColors.primary,
    NotificationKind.taskReminder => AppColors.dueFg,
    NotificationKind.dealWon => AppColors.warning,
  };
}
