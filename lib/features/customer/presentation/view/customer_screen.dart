import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/segmented_tabs.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/customer_constants.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customer_cubit.dart';
import '../widgets/activity_timeline.dart';
import '../widgets/customer_bottom_bar.dart';
import '../widgets/customer_deals_tab.dart';
import '../widgets/customer_details_tab.dart';
import '../widgets/customer_invoices_tab.dart';
import '../widgets/customer_stats.dart';
import '../widgets/customer_top_bar.dart';
import '../widgets/profile_card.dart';

/// Customer profile: identity, headline figures and the section tabs.
class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key, String? customerId})
    : customerId = customerId ?? CustomerConstants.featuredCustomerId;

  /// Customer to show; the featured one when the route carries none.
  final String customerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomerCubit>()..load(customerId),
      child: const _CustomerView(),
    );
  }
}

class _CustomerView extends StatelessWidget {
  const _CustomerView();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CustomerCubit c) => c.state);
    final l10n = context.l10n;
    return AppBackground(
      blobs: CustomerDimens.blobs,
      bottomBar: const CustomerBottomBar(),
      child: SafeArea(
        top: false,
        bottom: false,
        child: StatusBody(
          status: state.status,
          failure: state.failure,
          onRetry: context.read<CustomerCubit>().load,
          builder: (context) => ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(CustomerDimens.topPadding),
              AppSpacing.gutter,
              AppSizes.bottomBarClearance,
            ),
            children: [
              const CustomerTopBar(),
              const SizedBox(height: AppSpacing.s16),
              const ProfileCard(),
              const SizedBox(height: AppSpacing.s16),
              const CustomerStats(),
              const SizedBox(height: AppSpacing.s16),
              SegmentedTabs(
                labels: [
                  l10n.tabActivity,
                  l10n.invoices,
                  l10n.navPipeline,
                  l10n.tabData,
                ],
                selected: state.tab,
                onChanged: context.read<CustomerCubit>().selectTab,
              ),
              const SizedBox(height: AppSpacing.s16),
              switch (state.tab) {
                CustomerConstants.tabInvoices => const CustomerInvoicesTab(),
                CustomerConstants.tabDeals => const CustomerDealsTab(),
                CustomerConstants.tabDetails => const CustomerDetailsTab(),
                _ => const ActivityTimeline(),
              },
            ],
          ),
        ),
      ),
    );
  }
}
