import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_dates.dart';

/// Read-only payment date field that opens a date picker when tapped.
class PaymentDateField extends StatefulWidget {
  const PaymentDateField({
    super.key,
    required this.date,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  });

  final DateTime date;

  /// Earliest and latest date the picker offers.
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;

  @override
  State<PaymentDateField> createState() => _PaymentDateFieldState();
}

class _PaymentDateFieldState extends State<PaymentDateField> {
  final _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(PaymentDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sync() => _controller.text = context.dateOrToday(widget.date);

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.paymentDate;
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: _pick,
        child: AbsorbPointer(
          child: AppTextField(
            label: label,
            controller: _controller,
            height: InvoicesDimens.fieldHeight,
            fontSize: InvoicesDimens.fieldFontSize,
          ),
        ),
      ),
    );
  }
}
