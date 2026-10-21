import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../constants/search_dimens.dart';
import '../cubit/search_cubit.dart';
import 'clear_recents_button.dart';
import 'recent_search_row.dart';
import 'search_message.dart';

/// What the screen shows before anything is typed: the remembered queries
/// with a clear action, or a friendly hint when there are none.
class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final recents = context.select((SearchCubit c) => c.state.recents);
    if (recents.isEmpty) {
      return SearchMessage(
        title: l10n.searchIdleTitle,
        hint: l10n.searchIdleHint,
      );
    }
    final cubit = context.read<SearchCubit>();
    return ListView(
      padding: EdgeInsets.only(
        bottom: context.bottomPad(SearchDimens.bottomPadding),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.searchRecentTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label.restyle(
                  fontSize: SearchDimens.headingFont,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSubtle,
                ),
              ),
            ),
            ClearRecentsButton(onPressed: cubit.clearRecents),
          ],
        ),
        const SizedBox(height: AppSpacing.s10),
        for (final query in recents) ...[
          RecentSearchRow(query: query, onTap: () => cubit.searchNow(query)),
          const SizedBox(height: AppSpacing.s10),
        ],
      ],
    );
  }
}
