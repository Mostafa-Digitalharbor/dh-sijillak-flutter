import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../constants/search_dimens.dart';

/// Centred icon, title and hint, for the idle and no-results states.
class SearchMessage extends StatelessWidget {
  const SearchMessage({super.key, required this.title, required this.hint});

  final String title;
  final String hint;

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
                    icon: AppIcons.search,
                    size: SearchDimens.messageIconTile,
                    iconSize: SearchDimens.messageIconSize,
                    radius: AppRadius.r24,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyBold,
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  Text(
                    hint,
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
