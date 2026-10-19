import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/customer_dimens.dart';

/// Frosted list row: [leading] tile, a bold [title] over a [subtitle], and a
/// [trailing] figure that shrinks to fit. Tappable when [onTap] is given.
class CustomerRowCard extends StatelessWidget {
  const CustomerRowCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.s14),
        radius: AppRadius.r18,
        fill: AppColors.white74,
        shadow: false,
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              flex: CustomerDimens.rowTextFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold.restyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Flexible(
              flex: CustomerDimens.rowTrailingFlex,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
