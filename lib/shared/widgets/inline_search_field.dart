import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import 'app_text_field.dart';

/// Inline search box shown under a list header. It reports every edit through
/// [onChanged] (the owner debounces) and takes focus when it appears.
class InlineSearchField extends StatefulWidget {
  const InlineSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.initialQuery = '',
    this.height = AppSizes.fieldHeight,
    this.fontSize = 16,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final String initialQuery;
  final double height;
  final double fontSize;

  @override
  State<InlineSearchField> createState() => _InlineSearchFieldState();
}

class _InlineSearchFieldState extends State<InlineSearchField> {
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
        hint: widget.hint,
        controller: _controller,
        onChanged: widget.onChanged,
        height: widget.height,
        fontSize: widget.fontSize,
      ),
    );
  }
}
