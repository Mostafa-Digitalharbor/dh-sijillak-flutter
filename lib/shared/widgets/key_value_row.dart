import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';

/// Label on the start side and a value (text or any widget) on the end side,
/// optionally closed by a hairline.
class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.divider = false,
    this.ltrValue = false,
  }) : assert(value != null || trailing != null);

  static const double _textSize = 14;

  final String label;

  /// Plain-text value; ignored when [trailing] is given.
  final String? value;
  final Widget? trailing;
  final bool divider;

  /// Render [value] left-to-right (phone numbers, emails, ids) even in RTL.
  final bool ltrValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      decoration: BoxDecoration(
        border: divider
            ? const Border(
                bottom: BorderSide(
                  color: AppColors.borderSoft,
                  width: AppSizes.borderThin,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.subtitle.restyle(fontSize: _textSize),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: trailing != null
                  ? FittedBox(fit: BoxFit.scaleDown, child: trailing)
                  : Text(
                      value!,
                      textAlign: TextAlign.end,
                      textDirection: ltrValue ? TextDirection.ltr : null,
                      style: AppTextStyles.bodyBold.restyle(
                        fontSize: _textSize,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
