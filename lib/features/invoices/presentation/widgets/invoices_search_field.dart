import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../constants/invoices_dimens.dart';

/// Inline search box of the invoices list. It reports every edit through
/// [onChanged] (the owner debounces) and takes focus when it appears.
class InvoicesSearchField extends StatefulWidget {
  const InvoicesSearchField({
    super.key,
    required this.onChanged,
    this.initialQuery = '',
  });

  final ValueChanged<String> onChanged;
  final String initialQuery;

  @override
  State<InvoicesSearchField> createState() => _InvoicesSearchFieldState();
}

class _InvoicesSearchFieldState extends State<InvoicesSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );

  /// Scope around the field, used to hand the focus to it once it is built.
  final _scope = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scope.nextFocus();
    });
  }

  @override
  void dispose() {
    _scope.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _scope,
      child: AppTextField(
        hint: context.l10n.invoicesSearchHint,
        controller: _controller,
        onChanged: widget.onChanged,
        height: InvoicesDimens.fieldHeight,
        fontSize: InvoicesDimens.fieldFontSize,
      ),
    );
  }
}
