import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/formatting/time_l10n.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../domain/entities/app_notification.dart';
import '../constants/notifications_dimens.dart';
import '../extensions/notification_l10n.dart';
import '../extensions/notification_style.dart';

/// One notification: kind icon, headline, detail, time and an unread dot.
class NotificationRow extends StatelessWidget {
  const NotificationRow({
    super.key,
    required this.notification,
    required this.now,
    required this.onTap,
  });

  final AppNotification notification;

  /// The moment relative times are measured from.
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    final body = notification.body(context);
    return Semantics(
      button: true,
      label: [
        if (unread) context.l10n.notifUnreadMark,
        notification.title(context),
        body,
      ].join(' '),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.s14),
          radius: AppRadius.r18,
          fill: unread ? AppColors.white85 : AppColors.white74,
          shadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: notification.kind.icon,
                size: NotificationsDimens.rowIconTile,
                iconSize: NotificationsDimens.rowIconSize,
                radius: AppRadius.r14,
                background: notification.kind.background,
                foreground: notification.kind.foreground,
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyBold.restyle(
                        fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      context.relativePast(notification.createdAt, now: now),
                      style: AppTextStyles.caption.restyle(
                        color: AppColors.placeholder,
                      ),
                    ),
                  ],
                ),
              ),
              if (unread) ...[
                const SizedBox(width: AppSpacing.s10),
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.s6),
                  child: _UnreadDot(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: NotificationsDimens.unreadDot,
      height: NotificationsDimens.unreadDot,
      decoration: const BoxDecoration(
        color: AppColors.warning,
        shape: BoxShape.circle,
      ),
    );
  }
}
