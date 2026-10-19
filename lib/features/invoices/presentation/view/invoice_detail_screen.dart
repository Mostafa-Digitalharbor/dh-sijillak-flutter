import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/glass_bottom_bar.dart';
import '../../../../shared/widgets/glass_icon_button.dart';
import '../../../../shared/widgets/screen_header.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/invoices_defaults.dart';
import '../constants/invoices_dimens.dart';
import '../cubit/invoice_cubit.dart';
import '../widgets/invoice_detail_actions.dart';
import '../widgets/invoice_document_card.dart';
import '../widgets/invoice_status_badges.dart';

/// Invoice detail with its payment status and the record-payment action.
class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final number =
        GoRouterState.of(context).extra as int? ??
        InvoicesDefaults.invoiceNumber;
    return BlocProvider(
      create: (_) => getIt<InvoiceCubit>()..load(number),
      child: _InvoiceDetailView(number: number),
    );
  }
}

class _InvoiceDetailView extends StatelessWidget {
  const _InvoiceDetailView({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InvoiceCubit>();
    final state = context.watch<InvoiceCubit>().state;
    final invoice = state.invoice;
    return AppBackground(
      blobs: InvoicesDimens.detailBlobs,
      bottomBar: invoice == null
          ? null
          : GlassBottomBar(
              child: InvoiceDetailActions(
                invoice: invoice,
                onPaymentRecorded: cubit.reload,
              ),
            ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            context.topPad(InvoicesDimens.topPadding),
            AppSpacing.gutter,
            AppSizes.bottomBarClearance,
          ),
          children: [
            ScreenHeader(
              title: context.l10n.invoiceNo(context.digits('$number')),
              trailing: GlassIconButton(
                icon: AppIcons.download,
                label: context.l10n.download,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.s14),
            StatusBody(
              status: state.status,
              failure: state.failure,
              onRetry: cubit.reload,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InvoiceStatusBadges(invoice: invoice!),
                  const SizedBox(height: AppSpacing.s14),
                  InvoiceDocumentCard(invoice: invoice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
