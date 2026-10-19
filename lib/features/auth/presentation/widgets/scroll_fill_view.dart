import 'package:flutter/material.dart';

/// Scrolls [child] when it is taller than the viewport; otherwise stretches
/// it to the viewport so a `Spacer` inside a [Column] pins the last widgets
/// to the bottom.
class ScrollFillView extends StatelessWidget {
  const ScrollFillView({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (box.maxHeight - padding.vertical).clamp(
              0,
              double.infinity,
            ),
          ),
          child: IntrinsicHeight(child: child),
        ),
      ),
    );
  }
}
