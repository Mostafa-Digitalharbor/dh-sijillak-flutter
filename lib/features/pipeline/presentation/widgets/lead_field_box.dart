import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

/// White bordered box the size of a text field, holding a picker's content.
class LeadFieldBox extends StatelessWidget {
  const LeadFieldBox({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.r14);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          height: AppSizes.compactFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          child: child,
        ),
      ),
    );
  }
}
