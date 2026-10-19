import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../constants/home_dimens.dart';
import '../cubit/home_cubit.dart';
import 'notification_bell.dart';

/// Avatar, greeting with the user's name, and the notifications bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((HomeCubit c) => c.state.overview!.user);
    return Row(
      children: [
        Semantics(
          button: true,
          label: context.l10n.settingsOpenAccount,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.account),
            child: InitialsBadge(
              text: initialsOf(user.firstName, maxLetters: 1),
              size: HomeDimens.avatarSize,
              fontSize: HomeDimens.avatarFont,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.goodMorning,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.subtitle.restyle(
                  fontSize: HomeDimens.greetingFont,
                ),
              ),
              Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title.restyle(
                  fontSize: HomeDimens.userNameFont,
                ),
              ),
            ],
          ),
        ),
        const NotificationBell(),
      ],
    );
  }
}
