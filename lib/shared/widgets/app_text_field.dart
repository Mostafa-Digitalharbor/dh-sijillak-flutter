import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';

/// Single-line text input with an optional label above it.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.ltr = false,
    this.borderColor = AppColors.border,
    this.inputFormatters,
    this.height = AppSizes.fieldHeight,
    this.fontSize = 16,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;

  /// Latin content (email, URL): LTR direction, text aligned to the right.
  final bool ltr;
  final Color borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // The design's inputs are `content-box`: [height] is the inner height and
    // the border adds its width on both sides.
    final outer = height + AppSizes.borderThin * 2;
    final field = SizedBox(
      height: outer,
      child: TextField(
        // Single line (also required by obscured fields); the vertical
        // padding below centres the text in the fixed-height box.
        maxLines: 1,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        textDirection: ltr ? TextDirection.ltr : null,
        textAlign: ltr ? TextAlign.right : TextAlign.start,
        style: AppFonts.tajawal(fontSize: fontSize, color: AppColors.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppFonts.tajawal(
            fontSize: fontSize,
            color: AppColors.placeholder,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical:
                ((outer - AppFonts.lineBox(fontSize, FontWeight.w400)) / 2)
                    .clamp(0, double.infinity),
          ),
          enabledBorder: _border(borderColor),
          focusedBorder: _border(AppColors.accent, AppSizes.borderMedium),
        ),
      ),
    );
    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.s6),
        field,
      ],
    );
  }

  static OutlineInputBorder _border(
    Color color, [
    double width = AppSizes.borderThin,
  ]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.r14),
    borderSide: BorderSide(color: color, width: width),
  );
}
