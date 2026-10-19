import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tinted pill showing a workspace address (always left-to-right), with an
/// optional leading status dot.
class WorkspaceUrlChip extends StatelessWidget {
  const WorkspaceUrlChip({
    super.key,
    required this.url,
    required this.fontSize,
    required this.padding,
    this.dotSize,
  });

  final String url;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  /// Diameter of the accent dot before the address; none when null.
  final double? dotSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.tint,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotSize != null) ...[
            Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
          ],
          Flexible(
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              style: AppTextStyles.link.restyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
