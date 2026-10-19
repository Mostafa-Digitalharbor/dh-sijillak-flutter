import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import 'home_stat_card.dart';

/// Side-by-side "invoices due" and "open deals" cards.
class HomeStatCards extends StatelessWidget {
  const HomeStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = context.select((HomeCubit c) => c.state.overview!.summary);
    return Row(
      children: [
        Expanded(
          child: HomeStatCard(
            label: context.l10n.dueInvoices,
            value: context.amount(summary.dueAmount),
            unit: context.l10n.sar,
            note: context.l10n.overdueCount(
              context.digits('${summary.overdueInvoices}'),
            ),
            noteColor: AppColors.overdue,
            onTap: () => context.go(AppRoutes.invoices),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: HomeStatCard(
            label: context.l10n.openDeals,
            value: context.digits('${summary.openDeals}'),
            note: context.l10n.amountExpected(
              context.amount(summary.expectedDealsValue),
            ),
            noteColor: AppColors.primary,
            onTap: () => context.go(AppRoutes.pipeline),
          ),
        ),
      ],
    );
  }
}
