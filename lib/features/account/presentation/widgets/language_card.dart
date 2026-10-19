import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/segmented_tabs.dart';
import '../../domain/entities/app_language.dart';
import '../constants/account_dimens.dart';
import '../cubit/locale_cubit.dart';
import '../extensions/app_language_label.dart';

/// Language row with a segmented control; each language is named in itself.
class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final active = Localizations.localeOf(context).languageCode;
    final selected = AppLanguage.values.indexWhere((l) => l.code == active);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconTile(
                icon: AppIcons.globe,
                size: AccountDimens.languageIconBox,
                iconSize: AccountDimens.languageIconSize,
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  context.l10n.settingsLanguage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyBold.restyle(
                    fontSize: AccountDimens.languageTitleFont,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          SegmentedTabs(
            labels: [for (final l in AppLanguage.values) l.nativeName],
            selected: selected < 0 ? 0 : selected,
            onChanged: (i) =>
                context.read<LocaleCubit>().select(AppLanguage.values[i]),
          ),
        ],
      ),
    );
  }
}
