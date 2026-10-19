import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_background.dart';

/// Background blob layouts of every auth screen (geometry from the design).
abstract final class AuthBlobs {
  static const welcome = [
    BackgroundBlob(
      size: 340,
      color: AppColors.accent,
      opacity: 0.24,
      top: 400,
      left: -130,
    ),
    BackgroundBlob(
      size: 260,
      color: AppColors.primary,
      opacity: 0.16,
      top: 620,
      right: -90,
    ),
  ];

  static const login = [
    BackgroundBlob(
      size: 320,
      color: AppColors.accent,
      opacity: 0.22,
      top: 420,
      left: -120,
    ),
    BackgroundBlob(
      size: 260,
      color: AppColors.primary,
      opacity: 0.16,
      top: 640,
      right: -90,
    ),
  ];

  static const company = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 380,
      left: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 620,
      right: -80,
    ),
  ];

  static const account = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 200,
      right: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 620,
      left: -80,
    ),
  ];

  static const otp = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 120,
      left: -120,
    ),
  ];

  static const tax = [
    BackgroundBlob(
      size: 300,
      color: AppColors.accent,
      opacity: 0.22,
      top: 300,
      left: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 640,
      right: -80,
    ),
  ];

  static const brand = [
    BackgroundBlob(
      size: 320,
      color: AppColors.accent,
      opacity: 0.24,
      top: 380,
      right: -120,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 640,
      left: -80,
    ),
  ];

  static const done = [
    BackgroundBlob(
      size: 360,
      color: AppColors.accent,
      opacity: 0.28,
      top: 40,
      left: 15,
    ),
    BackgroundBlob(
      size: 240,
      color: AppColors.primary,
      opacity: 0.14,
      top: 620,
      right: -80,
    ),
  ];
}
