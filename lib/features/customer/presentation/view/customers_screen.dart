import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customers_cubit.dart';
import '../widgets/customers_header.dart';
import '../widgets/customers_list_body.dart';

/// Customers tab: searchable list of every customer.
class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomersCubit>()..load(),
      child: const _CustomersView(),
    );
  }
}

class _CustomersView extends StatelessWidget {
  const _CustomersView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomersCubit>();
    final state = context.watch<CustomersCubit>().state;
    return AppBackground(
      blobs: CustomerDimens.blobs,
      child: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            context.topPad(CustomerDimens.listTopPadding),
            AppSpacing.gutter,
            AppSizes.navClearance,
          ),
          children: [
            const CustomersHeader(),
            const SizedBox(height: AppSpacing.s16),
            StatusBody(
              status: state.status,
              failure: state.failure,
              onRetry: cubit.load,
              builder: (_) => CustomersListBody(
                customers: state.customers,
                filtered: state.query.trim().isNotEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
