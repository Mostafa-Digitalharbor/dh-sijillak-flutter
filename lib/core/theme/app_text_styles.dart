import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

abstract final class AppTextStyles {
  static TextStyle _base(double size, FontWeight weight, Color color) =>
      AppFonts.tajawal(fontSize: size, fontWeight: weight, color: color);

  static final title = _base(26, FontWeight.w800, AppColors.ink);
  static final titleLarge = _base(28, FontWeight.w800, AppColors.ink);
  static final subtitle = _base(15, FontWeight.w400, AppColors.textMuted);
  static final label = _base(14, FontWeight.w700, AppColors.textStrong);
  static final body = _base(16, FontWeight.w400, AppColors.ink);
  static final bodyBold = _base(15, FontWeight.w700, AppColors.ink);
  static final caption = _base(12, FontWeight.w400, AppColors.textMuted);
  static final captionBold = _base(13, FontWeight.w700, AppColors.textSubtle);
  static final button = _base(17, FontWeight.w800, Colors.white);
  static final link = _base(14, FontWeight.w700, AppColors.primary);
}
