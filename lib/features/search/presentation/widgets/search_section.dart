import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/search_dimens.dart';

/// A result group: its heading with the hit count, then the [rows].
class SearchSection extends StatelessWidget {
  const SearchSection({super.key, required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.searchSectionHeading(
            title,
            context.digits('${rows.length}'),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.label.restyle(
            fontSize: SearchDimens.headingFont,
            fontWeight: FontWeight.w800,
            color: AppColors.textSubtle,
          ),
        ),
        const SizedBox(height: AppSpacing.s10),
        for (final row in rows) ...[
          row,
          const SizedBox(height: AppSpacing.s10),
        ],
        const SizedBox(height: AppSpacing.s6),
      ],
    );
  }
}
