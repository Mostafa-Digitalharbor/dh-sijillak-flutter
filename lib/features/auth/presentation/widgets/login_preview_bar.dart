import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

/// A placeholder input / button bar inside the login preview card.
class LoginPreviewBar extends StatelessWidget {
  const LoginPreviewBar({
    super.key,
    required this.height,
    this.color = Colors.white,
    this.bordered = false,
  });

  final double height;
  final Color color;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.r8),
        border: bordered ? Border.all(color: AppColors.borderSoft) : null,
      ),
    );
  }
}
