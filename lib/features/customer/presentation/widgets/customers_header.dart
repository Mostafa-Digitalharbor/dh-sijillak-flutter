import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_icon_button.dart';
import '../../../../shared/widgets/inline_search_field.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customers_cubit.dart';

/// Title with the customer count and the search toggle, with the inline
/// search field underneath while it is open.
class CustomersHeader extends StatelessWidget {
  const CustomersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CustomersCubit>();
    final searching = context.select((CustomersCubit c) => c.state.searching);
    final count = context.select(
      (CustomersCubit c) => c.state.customers.length,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.navCustomers,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title,
                  ),
                  Text(
                    l10n.customersCount(context.digits('$count')),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle.restyle(
                      fontSize: CustomerDimens.listSubtitleFont,
                    ),
                  ),
                ],
              ),
            ),
            GlassIconButton(
              icon: searching ? AppIcons.close : AppIcons.search,
              label: searching ? l10n.closeSearch : l10n.search,
              onPressed: cubit.toggleSearch,
            ),
          ],
        ),
        if (searching) ...[
          const SizedBox(height: AppSpacing.s12),
          InlineSearchField(
            hint: l10n.customersSearchHint,
            onChanged: cubit.search,
            height: CustomerDimens.searchFieldHeight,
            fontSize: CustomerDimens.searchFieldFont,
          ),
        ],
      ],
    );
  }
}
