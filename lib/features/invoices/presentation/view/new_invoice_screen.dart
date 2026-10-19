import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/glass_bottom_bar.dart';
import '../../../../shared/widgets/screen_header.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/invoices_dimens.dart';
import '../cubit/new_invoice_cubit.dart';
import '../widgets/add_product_sheet.dart';
import '../widgets/new_invoice_bar.dart';
import '../widgets/new_invoice_body.dart';

/// Draft invoice editor: customer, terms, lines and totals.
class NewInvoiceScreen extends StatelessWidget {
  const NewInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Opened from a quote: the route carries the quote number to convert.
    final quoteNumber = GoRouterState.of(context).extra as int?;
    return BlocProvider(
      create: (_) => getIt<NewInvoiceCubit>()..load(quoteNumber: quoteNumber),
      child: const _NewInvoiceView(),
    );
  }
}

class _NewInvoiceView extends StatelessWidget {
  const _NewInvoiceView();

  Future<void> _addProduct(BuildContext context) async {
    final cubit = context.read<NewInvoiceCubit>();
    final line = await showAddProductSheet(context);
    if (line != null) cubit.addLine(line);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewInvoiceCubit>().state;
    final cubit = context.read<NewInvoiceCubit>();
    final draft = state.draft;
    // The pinned bar grows with the system font scale.
    final barClearance =
        InvoicesDimens.newInvoiceBarClearance *
        math.max(1.0, MediaQuery.textScalerOf(context).scale(1));
    return BlocListener<NewInvoiceCubit, NewInvoiceState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        final issued = state.issued;
        if (issued != null) {
          context.pushReplacement(AppRoutes.invoice, extra: issued.number);
        } else if (state.submitFailure != null) {
          showFailureSnackBar(context, state.submitFailure!);
        }
      },
      child: AppBackground(
        blobs: InvoicesDimens.newInvoiceBlobs,
        bottomBar: draft == null
            ? null
            : GlassBottomBar(
                child: NewInvoiceBar(
                  totals: draft.totals,
                  submitting: state.isSubmitting,
                  onIssue: cubit.issue,
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
              barClearance,
            ),
            children: [
              ScreenHeader(title: context.l10n.newInvoice, close: true),
              const SizedBox(height: AppSpacing.s14),
              StatusBody(
                status: state.status,
                failure: state.failure,
                onRetry: cubit.reload,
                builder: (_) => NewInvoiceBody(
                  draft: draft!,
                  onQuantityChanged: cubit.changeQuantity,
                  onAddProduct: () => _addProduct(context),
                  onRemoveLine: cubit.removeLine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
