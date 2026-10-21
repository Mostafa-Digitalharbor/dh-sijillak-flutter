import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../constants/notifications_dimens.dart';

/// Shown when the user has no notifications.
class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const IconTile(
                    icon: AppIcons.bell,
                    size: NotificationsDimens.emptyIconTile,
                    iconSize: NotificationsDimens.emptyIconSize,
                    radius: AppRadius.r24,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    context.l10n.notifEmptyTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyBold,
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  Text(
                    context.l10n.notifEmptyHint,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
