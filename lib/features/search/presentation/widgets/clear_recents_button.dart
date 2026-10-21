import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/search_dimens.dart';

/// Text action that forgets the recent searches.
class ClearRecentsButton extends StatelessWidget {
  const ClearRecentsButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.searchClearRecent;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: SearchDimens.clearMaxWidth),
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.link.restyle(
              fontSize: SearchDimens.clearFont,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
