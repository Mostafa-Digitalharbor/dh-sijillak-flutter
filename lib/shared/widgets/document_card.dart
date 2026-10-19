import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_shadows.dart';

/// Raised white sheet that holds a quote or invoice document.
class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        boxShadow: AppShadows.document,
      ),
      child: child,
    );
  }
}
