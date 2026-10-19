import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/responsive.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/invoices_defaults.dart';
import '../constants/invoices_dimens.dart';
import '../cubit/payment_done_cubit.dart';
import '../widgets/payment_done_body.dart';

/// Confirmation shown after a payment was recorded against an invoice.
class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final number =
        GoRouterState.of(context).extra as int? ??
        InvoicesDefaults.paidInvoiceNumber;
    return BlocProvider(
      create: (_) => getIt<PaymentDoneCubit>()..load(number),
      child: const _PaymentDoneView(),
    );
  }
}

class _PaymentDoneView extends StatelessWidget {
  const _PaymentDoneView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentDoneCubit>();
    final state = context.watch<PaymentDoneCubit>().state;
    final l10n = context.l10n;
    return AppBackground(
      blobs: InvoicesDimens.doneBlobs,
      child: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  context.topPad(
                    context.scaledY(InvoicesDimens.doneTopPadding),
                  ),
                  AppSpacing.gutter,
                  context.bottomPad(InvoicesDimens.doneBottomPadding),
                ),
                child: Column(
                  children: [
                    StatusBody(
                      status: state.status,
                      failure: state.failure,
                      onRetry: cubit.reload,
                      builder: (_) => PaymentDoneBody(
                        invoice: state.invoice!,
                        payment: state.payment!,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.s18),
                    PrimaryButton(
                      label: l10n.sendReceipt,
                      icon: AppIcons.message,
                      onPressed: () {},
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    SecondaryButton(
                      label: l10n.backToInvoices,
                      onPressed: () => context.go(AppRoutes.invoices),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
