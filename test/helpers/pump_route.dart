import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/repositories/session_store.dart';

/// A device configuration a screen must survive without layout errors.
class DeviceSpec {
  const DeviceSpec(this.name, this.size, {this.textScale = 1, this.platform});

  final String name;
  final Size size;
  final double textScale;

  /// Platform to emulate; null keeps the test default (android).
  final TargetPlatform? platform;

  static const all = [
    DeviceSpec('small phone', Size(320, 568)),
    DeviceSpec('small phone, large text', Size(320, 568), textScale: 1.5),
    DeviceSpec('regular phone', Size(390, 844)),
    DeviceSpec('regular phone, large text', Size(390, 844), textScale: 1.5),
    DeviceSpec('tablet', Size(820, 1180)),
    DeviceSpec('landscape phone', Size(844, 390)),
    DeviceSpec('iPhone SE', Size(375, 667), platform: TargetPlatform.iOS),
    DeviceSpec(
      'iPhone 15 Pro Max, large text',
      Size(430, 932),
      textScale: 1.3,
      platform: TargetPlatform.iOS,
    ),
    DeviceSpec(
      'Galaxy Fold folded',
      Size(280, 653),
      platform: TargetPlatform.android,
    ),
    DeviceSpec('Pixel Tablet portrait', Size(800, 1280)),
  ];
}

/// Tests render with a square placeholder font unless the real one is
/// loaded; overflow checks are only meaningful with real glyph widths. The
/// loader cannot tell weights apart, so the bold file is used for all text:
/// a slightly pessimistic width, never an optimistic one.
Future<void> loadAppFonts() async {
  final loader = FontLoader('Tajawal');
  loader.addFont(rootBundle.load('assets/fonts/Tajawal-Bold.ttf'));
  await loader.load();
}

/// Sizes the test surface like [spec] and applies its text scale and platform.
///
/// The view and text scale are restored when the test ends. The platform
/// override is not: the framework checks foundation overrides before
/// tear-downs run, so callers must call [resetPlatform] before their test
/// body returns ([pumpRoute] does it once the route has settled).
void applyDevice(WidgetTester tester, DeviceSpec spec) {
  tester.view.physicalSize = spec.size * 2;
  tester.view.devicePixelRatio = 2;
  tester.platformDispatcher.textScaleFactorTestValue = spec.textScale;
  debugDefaultTargetPlatformOverride = spec.platform;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

/// Clears the platform override set by [applyDevice].
void resetPlatform() => debugDefaultTargetPlatformOverride = null;

/// Opens [route] in the real app on [spec]. Any layout overflow or build
/// error is reported by the test framework as an exception.
Future<void> pumpRoute(
  WidgetTester tester,
  String route,
  DeviceSpec spec, {
  Locale locale = const Locale('ar'),
  AuthSession? session,
}) async {
  applyDevice(tester, spec);
  await loadAppFonts();
  SharedPreferences.setMockInitialValues({});
  await configureDependencies(latency: Duration.zero);
  if (session != null) getIt<SessionStore>().save(session);
  try {
    appRouter.go(route);
    await tester.pumpWidget(SijilakApp(locale: locale));
    // Fixtures load through real asset IO, which the fake-async test clock
    // does not advance on its own.
    await settle(tester);
  } finally {
    resetPlatform();
  }
}

/// Lets real asset IO complete and animations finish. The fake-async test
/// clock does not advance real IO, so it is awaited with `runAsync` between
/// two ordinary pumps.
Future<void> settle(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 150)),
  );
  await tester.pump(const Duration(milliseconds: 500));
}
