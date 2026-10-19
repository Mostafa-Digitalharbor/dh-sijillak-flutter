import 'package:flutter/material.dart';

import '../../../../core/constants/app_config.dart';

import 'package:flutter/services.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/auth_dimens.dart';

/// Pill showing the workspace address; tapping it copies the full link.
class WorkspaceLinkCopyChip extends StatelessWidget {
  const WorkspaceLinkCopyChip({super.key, required this.url});

  final String url;

  Future<void> _copy(BuildContext context) async {
    final message = context.l10n.linkCopied;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(
      ClipboardData(text: '${AppConfig.workspaceScheme}$url'),
    );
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white80,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.glassBorder),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => _copy(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.link.restyle(
                    fontSize: AuthDimens.doneChipFont,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              AppIcon(
                AppIcons.copy,
                size: AuthDimens.doneChipIcon,
                color: AppColors.primary,
                semanticLabel: context.l10n.copy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
