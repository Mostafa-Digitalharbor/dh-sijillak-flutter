import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/dashed_action_button.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/payment_method.dart';
import '../constants/invoices_dimens.dart';
import '../cubit/payment_cubit.dart';
import '../extensions/invoice_l10n.dart';
import 'payment_amount_field.dart';
import 'payment_date_field.dart';
import 'payment_method_tile.dart';
import '../../../../shared/widgets/sheet_handle.dart';

/// Scrollable form of the payment sheet: amount, method, date, reference.
class PaymentSheetContent extends StatefulWidget {
  const PaymentSheetContent({super.key, required this.invoice});

  final InvoiceDetail invoice;

  @override
  State<PaymentSheetContent> createState() => _PaymentSheetContentState();
}

class _PaymentSheetContentState extends State<PaymentSheetContent> {
  final _reference = TextEditingController();
  TextEditingController? _amount;

  @override
  void dispose() {
    _amount?.dispose();
    _reference.dispose();
    super.dispose();
  }

  void _onResult(BuildContext context, PaymentState state) {
    final recorded = state.recorded;
    if (recorded != null) {
      final router = GoRouter.of(context);
      Navigator.of(context).pop();
      router.push(AppRoutes.paymentDone, extra: recorded.number);
    } else if (state.failure != null) {
      showFailureSnackBar(context, state.failure!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    _amount ??= TextEditingController(
      text: context.amount(widget.invoice.balance),
    );
    final cubit = context.read<PaymentCubit>();
    final state = context.watch<PaymentCubit>().state;
    return BlocListener<PaymentCubit, PaymentState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onResult,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.s10,
          AppSpacing.gutter,
          AppSpacing.s30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: AppSpacing.s14),
            Text(
              l10n.recordPayment,
              style: AppTextStyles.title.restyle(
                fontSize: InvoicesDimens.sheetTitleSize,
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              l10n.customerAndInvoice(
                widget.invoice.customer,
                context.digits('${widget.invoice.number}'),
              ),
              style: AppTextStyles.subtitle.restyle(
                fontSize: InvoicesDimens.sheetSubtitleSize,
              ),
            ),
            const SizedBox(height: AppSpacing.s14),
            PaymentAmountField(controller: _amount!),
            const SizedBox(height: AppSpacing.s14),
            Text(l10n.paymentMethod, style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.s8),
            Row(
              children: [
                for (final m in PaymentMethod.values) ...[
                  if (m != PaymentMethod.values.first)
                    const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: PaymentMethodTile(
                      method: m,
                      selected: m == state.method,
                      onTap: () => cubit.select(m),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.s14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PaymentDateField(
                    date: state.date,
                    firstDate: widget.invoice.issueDate,
                    lastDate: DateTime.now(),
                    onChanged: cubit.pickDate,
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: AppTextField(
                    label: state.method.referenceLabel(context),
                    hint: l10n.optional,
                    controller: _reference,
                    height: InvoicesDimens.fieldHeight,
                    fontSize: InvoicesDimens.fieldFontSize,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s14),
            DashedActionButton(
              icon: AppIcons.paperclip,
              label: state.hasReceipt
                  ? l10n.receiptAttached
                  : l10n.attachReceipt,
              onPressed: cubit.toggleReceipt,
              height: InvoicesDimens.attachHeight,
              radius: InvoicesDimens.attachRadius,
              iconSize: InvoicesDimens.attachIconSize,
              fontSize: InvoicesDimens.attachLabelSize,
            ),
            const SizedBox(height: AppSpacing.s14),
            PrimaryButton(
              label: l10n.confirmPaymentReceived,
              enabled: !state.isSubmitting,
              onPressed: () => cubit.submit(
                amountText: _amount!.text,
                reference: _reference.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
