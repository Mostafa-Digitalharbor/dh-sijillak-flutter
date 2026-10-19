import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_fonts.dart';

/// One entry of a [GrowRow]: a child plus what is needed to compute its
/// natural width (its label text and any fixed extra width).
class GrowItem {
  const GrowItem({
    required this.label,
    required this.fontSize,
    required this.child,
    this.fontWeight = FontWeight.w800,
    this.extraWidth = 0,
    this.grow = 1,
  });

  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  /// Fixed width added to the text (borders, icon + gap).
  final double extraWidth;

  /// CSS `flex-grow`.
  final int grow;
  final Widget child;
}

/// Lays out buttons like CSS `flex: <grow> 1 auto`: every item starts from its
/// natural (text) width and the remaining space is shared by `grow`, so a
/// button with a longer label ends up wider than its neighbour.
class GrowRow extends StatelessWidget {
  const GrowRow({super.key, required this.items, this.gap = AppSpacing.s10});

  final List<GrowItem> items;
  final double gap;

  double _natural(GrowItem item, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(
        text: item.label,
        style: AppFonts.tajawal(
          fontSize: item.fontSize,
          fontWeight: item.fontWeight,
        ),
      ),
      textDirection: TextDirection.rtl,
      textScaler: scaler,
      maxLines: 1,
    )..layout();
    return painter.width + item.extraWidth;
  }

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, box) {
        final natural = [for (final i in items) _natural(i, scaler)];
        final totalGrow = items.fold<int>(0, (s, i) => s + i.grow);
        final available = box.maxWidth - gap * (items.length - 1);
        final totalNatural = natural.reduce((a, b) => a + b);
        final free = available - totalNatural;
        // Too narrow for the natural widths: shrink every item evenly (the
        // buttons scale their labels down).
        final shrink = free < 0 ? available / totalNatural : 1.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              SizedBox(
                width: free > 0
                    ? natural[i] + free * items[i].grow / totalGrow
                    : natural[i] * shrink,
                child: items[i].child,
              ),
            ],
          ],
        );
      },
    );
  }
}
