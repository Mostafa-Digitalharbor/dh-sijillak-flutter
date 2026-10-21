import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'sheet_dimens.dart';

/// Tinted full-width action row of a picker sheet ("+ new customer").
class SheetActionTile extends StatelessWidget {
  const SheetActionTile({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r16);
    return Semantics(
      button: true,
      child: Material(
        color: AppColors.tint,
        borderRadius: shape,
        child: InkWell(
          borderRadius: shape,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: SheetDimens.tileMinHeight,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s14,
              vertical: AppSpacing.s10,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.link,
            ),
          ),
        ),
      ),
    );
  }
}
