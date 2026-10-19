import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/icons/app_icons.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_back_button.dart';
import 'glass_icon_button.dart';

/// Leading button + centred title + trailing widget (defaults to a spacer so
/// the title stays centred).
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.close = false,
    this.trailing,
  });

  final String title;

  /// Show a close button instead of the back chevron.
  final bool close;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        close
            ? GlassIconButton(
                icon: AppIcons.close,
                size: AppSizes.backButton,
                strokeWidth: AppSizes.borderThick,
                label: context.l10n.close,
                onPressed: () => context.pop(),
              )
            : const AppBackButton(),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyBold.restyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        trailing ?? const SizedBox(width: AppSizes.iconButton),
      ],
    );
  }
}
