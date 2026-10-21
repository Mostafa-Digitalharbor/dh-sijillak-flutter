import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/notifications_dimens.dart';
import '../cubit/notifications_cubit.dart';

/// Header text action that marks every notification as read; dimmed and
/// inert when nothing is unread.
class MarkAllReadButton extends StatelessWidget {
  const MarkAllReadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final hasUnread = context.select(
      (NotificationsCubit c) => c.state.unreadCount > 0,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: NotificationsDimens.markAllMaxWidth,
      ),
      child: Semantics(
        button: true,
        enabled: hasUnread,
        label: context.l10n.notifMarkAllRead,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: hasUnread
              ? context.read<NotificationsCubit>().markAllRead
              : null,
          child: Text(
            context.l10n.notifMarkAllRead,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.link.restyle(
              fontSize: NotificationsDimens.markAllFontSize,
              color: hasUnread ? AppColors.primary : AppColors.disabled,
            ),
          ),
        ),
      ),
    );
  }
}
