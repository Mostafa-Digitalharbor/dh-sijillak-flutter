import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/document_line.dart';
import '../constants/invoices_dimens.dart';
import '../utils/amount_input.dart';

/// Name and unit-price fields for an invoice line that is not in the
/// catalog, with the button that hands the typed line to [onSubmit].
class CustomItemForm extends StatefulWidget {
  const CustomItemForm({super.key, required this.onSubmit});

  final ValueChanged<DocumentLine> onSubmit;

  @override
  State<CustomItemForm> createState() => _CustomItemFormState();
}

class _CustomItemFormState extends State<CustomItemForm> {
  final _name = TextEditingController();
  final _price = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _price.addListener(_refresh);
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get _valid =>
      _name.text.trim().isNotEmpty && AmountInput.parse(_price.text) > 0;

  void _submit() => widget.onSubmit(
    DocumentLine(
      name: _name.text.trim(),
      unitPrice: AmountInput.parse(_price.text),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: l10n.itemNameLabel,
          hint: l10n.itemNameHint,
          controller: _name,
          height: InvoicesDimens.fieldHeight,
          fontSize: InvoicesDimens.fieldFontSize,
        ),
        const SizedBox(height: AppSpacing.s10),
        AppTextField(
          label: l10n.unitPriceLabel,
          controller: _price,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          height: InvoicesDimens.fieldHeight,
          fontSize: InvoicesDimens.fieldFontSize,
        ),
        const SizedBox(height: AppSpacing.s14),
        PrimaryButton(
          label: l10n.addToInvoice,
          icon: AppIcons.plus,
          enabled: _valid,
          onPressed: _submit,
        ),
      ],
    );
  }
}
