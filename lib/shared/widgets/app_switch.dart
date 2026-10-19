import 'package:flutter/material.dart';

import '../../core/constants/app_durations.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_colors.dart';

/// The design's pill toggle. Purely visual: the parent owns the tap.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value});

  final bool value;

  static const double _width = 50;
  static const double _height = 30;
  static const double _knob = 24;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.short,
      width: _width,
      height: _height,
      padding: const EdgeInsets.all(AppSpacing.s3),
      alignment: value
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : AppColors.switchOff,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Container(
        width: _knob,
        height: _knob,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowKnob,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
