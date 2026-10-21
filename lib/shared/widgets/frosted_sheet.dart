import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import 'sheet_frame.dart';

/// Opens [builder]'s content in the frosted bottom sheet shared by the
/// app's flows, resolving with whatever the content pops.
///
/// Built on a general dialog (not `showModalBottomSheet`) so the backdrop can
/// be blurred and dimmed like the design.
Future<T?> showFrostedSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: context.l10n.close,
    barrierColor: Colors.transparent,
    transitionDuration: AppDurations.sheet,
    pageBuilder: (dialogContext, _, _) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(dialogContext).pop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppBlur.backdrop,
                sigmaY: AppBlur.backdrop,
              ),
              child: const ColoredBox(color: AppColors.scrim),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SheetFrame(child: builder(dialogContext)),
        ),
      ],
    ),
    transitionBuilder: (_, animation, _, child) => SlideTransition(
      position: Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}
