import 'package:flutter/painting.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';

/// Shadows specific to the auth feature.
abstract final class AuthShadows {
  /// Miniature login page on the brand step.
  static final previewCard = AppShadows.tinted(alpha: 0.12, blur: 30, dy: 14);

  /// Phone badge on the verification-code step.
  static final otpBadge = AppShadows.tinted(alpha: 0.1, blur: 20, dy: 8);

  /// Success check on the final step: a frosted ring plus a soft glow.
  static final doneBadge = [
    const BoxShadow(color: AppColors.white60, spreadRadius: 12),
    ...AppShadows.tinted(alpha: 0.3, blur: 34, dy: 16),
  ];
}
