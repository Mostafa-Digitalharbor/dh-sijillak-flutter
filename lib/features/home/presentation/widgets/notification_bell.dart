import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/cubit/unread_count_cubit.dart';
import '../constants/home_dimens.dart';

/// Round bell button: opens the notifications and shows a dot while some are
/// unread. The count is refreshed when the notifications screen is closed.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UnreadCountCubit>()..load(),
      child: const _BellButton(),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton();

  Future<void> _open(BuildContext context) async {
    final cubit = context.read<UnreadCountCubit>();
    await context.push(AppRoutes.notifications);
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<UnreadCountCubit>().state;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: unread > 0
          ? l10n.notifBellUnread(context.digits('$unread'), unread)
          : l10n.notifications,
      excludeSemantics: true,
      child: Material(
        color: AppColors.white70,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _open(context),
          child: SizedBox(
            width: AppSizes.backButton,
            height: AppSizes.backButton,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const AppIcon(
                  AppIcons.bell,
                  size: AppSizes.iconLg,
                  color: AppColors.ink,
                ),
                if (unread > 0)
                  Positioned(
                    top: HomeDimens.bellDotTop,
                    right: HomeDimens.bellDotRight,
                    child: Container(
                      width: HomeDimens.bellDot,
                      height: HomeDimens.bellDot,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: AppSizes.borderThick,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
