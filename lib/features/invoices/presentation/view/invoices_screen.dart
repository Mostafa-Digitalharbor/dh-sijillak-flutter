import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/invoices_dimens.dart';
import '../cubit/invoices_cubit.dart';
import '../widgets/invoices_header.dart';
import '../widgets/invoices_list_body.dart';

/// Invoices list with the billing summary and status tabs.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InvoicesCubit>()..load(),
      child: const _InvoicesView(),
    );
  }
}

class _InvoicesView extends StatelessWidget {
  const _InvoicesView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InvoicesCubit>();
    final state = context.watch<InvoicesCubit>().state;
    return AppBackground(
      blobs: InvoicesDimens.listBlobs,
      child: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            context.topPad(InvoicesDimens.listTopPadding),
            AppSpacing.gutter,
            InvoicesDimens.listBottomPadding,
          ),
          children: [
            const InvoicesHeader(),
            const SizedBox(height: AppSpacing.s16),
            StatusBody(
              status: state.status,
              failure: state.failure,
              onRetry: cubit.load,
              builder: (_) => InvoicesListBody(listing: state.listing!),
            ),
          ],
        ),
      ),
    );
  }
}
