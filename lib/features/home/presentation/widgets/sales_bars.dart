import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../constants/home_dimens.dart';

/// Decorative mini bar chart; the last bar (current day) is highlighted.
class SalesBars extends StatelessWidget {
  const SalesBars({super.key, required this.values});

  /// Relative height (0–1) of each bar.
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: HomeDimens.salesBarsHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < values.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: values[i],
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: i == values.length - 1
                          ? Colors.white
                          : AppColors.white28,
                      borderRadius: BorderRadius.circular(
                        HomeDimens.salesBarRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
