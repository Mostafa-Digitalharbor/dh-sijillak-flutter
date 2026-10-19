import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../../../shared/widgets/key_value_row.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../constants/account_dimens.dart';

/// Who is signed in: avatar, name, email and the workspace they belong to.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    final user = session.user;
    final workspace = session.workspace;
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              InitialsBadge(
                text: initialsOf(user.name),
                size: AccountDimens.avatarSize,
                fontSize: AccountDimens.avatarFont,
              ),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.restyle(
                        fontSize: AccountDimens.nameFont,
                      ),
                    ),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subtitle.restyle(
                        fontSize: AccountDimens.emailFont,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          KeyValueRow(
            label: context.l10n.settingsWorkspace,
            value: workspace.name,
            divider: true,
          ),
          KeyValueRow(
            label: context.l10n.settingsWorkspaceUrl,
            value: workspace.url,
          ),
        ],
      ),
    );
  }
}
