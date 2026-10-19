import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFEEF5F4);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF0B5C58);
  static const primaryDark = Color(0xFF08433F);
  static const accent = Color(0xFF12ACA5);
  static const tint = Color(0xFFE7F4F3);
  static const tintSoft = Color(0xFFF1F7F6);

  static const ink = Color(0xFF161B22);
  static const textStrong = Color(0xFF2B3736);
  static const textMuted = Color(0xFF4A5857);
  static const textSubtle = Color(0xFF3E4C4B);
  static const placeholder = Color(0xFF7A8A89);

  static const border = Color(0xFFD5E3E2);
  static const borderSoft = Color(0xFFE3EEED);
  static const borderButton = Color(0xFFCFE1E0);
  static const borderDashed = Color(0xFFB9D3D1);
  static const dashedStrong = Color(0xFF8FBDB9);
  static const disabled = Color(0xFF8FA9A7);
  static const switchOff = Color(0xFFC3D3D2);

  static const warning = Color(0xFFE0662F);
  static const error = Color(0xFFA3401A);
  static const amber = Color(0xFFE9B949);

  static const overdue = Color(0xFFB44B1C);
  static const overdueBg = Color(0xFFFCE3D6);
  static const dueBg = Color(0xFFFBF0D6);
  static const dueFg = Color(0xFF7A5A0C);
  static const paidBg = Color(0xFFDDF2F0);
  static const warmTint = Color(0xFFFCEFE7);
  static const docTint = Color(0xFFF4F9F8);
  static const navInactive = Color(0xFF5B6A69);
  static const brandSlate = Color(0xFF24324A);

  static const glassFill = Color(0xB8FFFFFF); // white @ 0.72
  static const glassBorder = Color(0xF2FFFFFF); // white @ 0.95

  // White overlays (frosted surfaces). Number = opacity percent.
  static const white16 = Color(0x29FFFFFF);
  static const white20 = Color(0x33FFFFFF);
  static const white28 = Color(0x47FFFFFF);
  static const white40 = Color(0x66FFFFFF);
  static const white55 = Color(0x8CFFFFFF);
  static const white60 = Color(0x99FFFFFF);
  static const white70 = Color(0xB3FFFFFF);
  static const white72 = Color(0xB8FFFFFF);
  static const white74 = Color(0xBDFFFFFF);
  static const white75 = Color(0xBFFFFFFF);
  static const white78 = Color(0xC7FFFFFF);
  static const white80 = Color(0xCCFFFFFF);
  static const white82 = Color(0xD1FFFFFF);
  static const white85 = Color(0xD9FFFFFF);
  static const white94 = Color(0xF0FFFFFF);

  // One-off tints
  static const shadowKnob = Color(0x33000000);
  static const scrim = Color(0x730F1E1E);
  static const stepRing = Color(0xFFBFE7E4);
  static const ringTeal = Color(0xFFD4EFED);
  static const ringWarm = Color(0xFFFADFD0);
  static const onPrimaryMuted = Color(0xFFCDEBE8);
}
