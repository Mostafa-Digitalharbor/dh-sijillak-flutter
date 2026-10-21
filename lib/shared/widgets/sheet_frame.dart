import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/layout/responsive.dart';
import '../../core/theme/app_colors.dart';
import 'sheet_dimens.dart';

/// Frosted rounded surface of a bottom sheet. It rises above the keyboard
/// and never grows taller than the free screen height, so its [child] scrolls
/// in landscape or with the keyboard open.
class SheetFrame extends StatelessWidget {
  const SheetFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = math.max(
      0.0,
      context.screenHeight -
          keyboard -
          MediaQuery.paddingOf(context).top -
          SheetDimens.topMargin,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(SheetDimens.radius),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: SheetDimens.blur,
                sigmaY: SheetDimens.blur,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white94,
                  boxShadow: SheetDimens.shadow,
                ),
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
