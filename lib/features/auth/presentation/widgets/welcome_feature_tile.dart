import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/icon_tile.dart';

/// One benefit row of the welcome screen: tinted icon + text.
class WelcomeFeatureTile extends StatelessWidget {
  const WelcomeFeatureTile({super.key, required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.s14),
      radius: AppRadius.r18,
      fill: AppColors.white70,
      shadow: false,
      child: Row(
        children: [
          IconTile(icon: icon),
          const SizedBox(width: AppSpacing.s12),
          Expanded(child: Text(text, style: AppTextStyles.bodyBold)),
        ],
      ),
    );
  }
}
