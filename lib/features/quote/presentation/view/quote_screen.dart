import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/glass_bottom_bar.dart';
import '../../../../shared/widgets/glass_icon_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/screen_header.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/quote_defaults.dart';
import '../constants/quote_dimens.dart';
import '../cubit/quote_cubit.dart';
import '../widgets/quote_body.dart';

/// Quote detail: progress, the document and the approval / conversion action.
class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final number =
        GoRouterState.of(context).extra as int? ?? QuoteDefaults.quoteNumber;
    return BlocProvider(
      create: (_) => getIt<QuoteCubit>()..load(number),
      child: _QuoteView(number: number),
    );
  }
}

class _QuoteView extends StatelessWidget {
  const _QuoteView({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuoteCubit>();
    final state = context.watch<QuoteCubit>().state;
    final l10n = context.l10n;
    final quote = state.quote;
    return BlocListener<QuoteCubit, QuoteState>(
      listenWhen: (previous, current) =>
          previous.confirmStatus != current.confirmStatus &&
          current.confirmFailure != null,
      listener: (context, state) =>
          showFailureSnackBar(context, state.confirmFailure!),
      child: AppBackground(
        blobs: QuoteDimens.blobs,
        bottomBar: quote == null
            ? null
            : GlassBottomBar(
                child: quote.isApproved
                    ? PrimaryButton(
                        label: l10n.convertToInvoice,
                        icon: AppIcons.doc,
                        height: QuoteDimens.actionButtonHeight,
                        radius: QuoteDimens.actionButtonRadius,
                        fontSize: QuoteDimens.actionButtonFont,
                        onPressed: () => context.push(
                          AppRoutes.newInvoice,
                          extra: quote.number,
                        ),
                      )
                    : PrimaryButton(
                        label: l10n.customerApprovedConfirm,
                        height: QuoteDimens.actionButtonHeight,
                        radius: QuoteDimens.actionButtonRadius,
                        fontSize: QuoteDimens.actionButtonFont,
                        enabled: !state.isConfirming,
                        onPressed: cubit.confirm,
                      ),
              ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(QuoteDimens.topPadding),
              AppSpacing.gutter,
              AppSizes.bottomBarClearance,
            ),
            children: [
              ScreenHeader(
                title: l10n.quoteNo(context.digits('$number')),
                trailing: GlassIconButton(
                  icon: AppIcons.edit,
                  label: l10n.edit,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: AppSpacing.s14),
              StatusBody(
                status: state.status,
                failure: state.failure,
                onRetry: cubit.reload,
                builder: (_) => QuoteBody(quote: quote!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
