import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';

/// Labelled dropdown styled like [AppTextField]. Uses the first item as the
/// initial selection.
class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.compact = false,
    this.onChanged,
  });

  final String label;
  final List<String> items;
  final ValueChanged<String>? onChanged;

  /// Smaller label and value, tighter padding (inline pairs of fields).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact
        ? const EdgeInsets.symmetric(
            horizontal: AppSpacing.s10,
            vertical: AppSpacing.s12,
          )
        : const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s13,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: compact ? AppTextStyles.caption : AppTextStyles.label,
        ),
        SizedBox(height: compact ? AppSpacing.s4 : AppSpacing.s6),
        DropdownButtonFormField<String>(
          initialValue: items.first,
          isExpanded: true,
          style: compact
              ? AppTextStyles.body.restyle(fontSize: 15)
              : AppTextStyles.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: padding,
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.accent, 1.5),
          ),
          items: [
            for (final item in items)
              DropdownMenuItem(value: item, child: Text(item)),
          ],
          onChanged: (value) {
            if (value != null) onChanged?.call(value);
          },
        ),
      ],
    );
  }

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r14),
        borderSide: BorderSide(color: color, width: width),
      );
}
