import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/initials.dart';
import 'initials_badge.dart';

/// Customer / company identity: optional initials badge, an optional small
/// eyebrow line, the bold name and an optional caption, plus a trailing widget.
class PartyHeader extends StatelessWidget {
  const PartyHeader({
    super.key,
    required this.name,
    this.eyebrow,
    this.subtitle,
    this.trailing,
    this.showBadge = true,
    this.badgeSize = 42,
    this.badgeFontSize = 15,
    this.nameSize,
    this.lineGap = 0,
  });

  static const double _badgeRadius = AppRadius.r14;

  final String name;

  /// Caption shown above the name.
  final String? eyebrow;

  /// Caption shown below the name.
  final String? subtitle;
  final Widget? trailing;
  final bool showBadge;
  final double badgeSize;
  final double badgeFontSize;

  /// Name font size; defaults to the app's bold body size.
  final double? nameSize;

  /// Vertical space between the stacked lines.
  final double lineGap;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: lineGap);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBadge) ...[
          InitialsBadge(
            text: initialsOf(name),
            size: badgeSize,
            radius: _badgeRadius,
            fontSize: badgeFontSize,
          ),
          const SizedBox(width: AppSpacing.s12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Text(eyebrow!, style: AppTextStyles.caption),
                gap,
              ],
              Text(
                name,
                style: AppTextStyles.bodyBold.restyle(
                  fontSize: nameSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                gap,
                Text(subtitle!, style: AppTextStyles.caption),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.s12),
          trailing!,
        ],
      ],
    );
  }
}
