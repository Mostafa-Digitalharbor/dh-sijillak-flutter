import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFonts.family,
      splashFactory: InkRipple.splashFactory,
    );
  }
}
