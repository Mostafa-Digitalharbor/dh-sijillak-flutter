import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_icon_button.dart';
import '../cubit/invoices_cubit.dart';
import 'invoices_period_button.dart';
import 'invoices_search_field.dart';

/// Title row of the invoices list (search toggle and period menu), with the
/// inline search field underneath while it is open.
class InvoicesHeader extends StatelessWidget {
  const InvoicesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<InvoicesCubit>();
    final searching = context.select((InvoicesCubit c) => c.state.searching);
    final period = context.select((InvoicesCubit c) => c.state.period);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.invoices, style: AppTextStyles.title)),
            GlassIconButton(
              icon: searching ? AppIcons.close : AppIcons.search,
              label: searching ? l10n.closeSearch : l10n.search,
              onPressed: cubit.toggleSearch,
            ),
            const SizedBox(width: AppSpacing.s10),
            InvoicesPeriodButton(
              period: period,
              onSelected: cubit.selectPeriod,
            ),
          ],
        ),
        if (searching) ...[
          const SizedBox(height: AppSpacing.s12),
          InvoicesSearchField(onChanged: cubit.search),
        ],
      ],
    );
  }
}
