import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import 'sheet_dimens.dart';
import 'sheet_handle.dart';

/// Scrollable content of a frosted sheet: grab handle, [title] and then
/// [children], stacked full width. Scrolls when the sheet is shorter than its
/// content (landscape, keyboard open, large text).
class FrostedSheetBody extends StatelessWidget {
  const FrostedSheetBody({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.s10,
        AppSpacing.gutter,
        AppSpacing.s30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetHandle(),
          const SizedBox(height: AppSpacing.s14),
          Text(
            title,
            style: AppTextStyles.title.restyle(fontSize: SheetDimens.titleSize),
          ),
          const SizedBox(height: AppSpacing.s14),
          ...children,
        ],
      ),
    );
  }
}
