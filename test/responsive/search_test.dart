import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/search/data/repositories/search_preferences_keys.dart';
import 'package:sijilak/features/search/presentation/widgets/customer_hit_row.dart';

import '../helpers/pump_route.dart';
import '../helpers/test_dependencies.dart';

/// Matches every group, so all four sections are on screen.
const _everything = 'ال';

/// Small phone, small phone with large text, and landscape.
final _devices = [DeviceSpec.all[0], DeviceSpec.all[1], DeviceSpec.all[5]];

/// Share of the screen height the keyboard covers.
const _keyboardShare = 0.4;

/// Opens the search screen on [device] with [recents] already remembered.
Future<void> _open(
  WidgetTester tester,
  DeviceSpec device,
  Locale locale,
  List<String> recents,
) async {
  applyDevice(tester, device);
  await loadAppFonts();
  SharedPreferences.setMockInitialValues({
    if (recents.isNotEmpty) SearchPreferencesKeys.recent: recents,
  });
  await configureTestDependencies();
  try {
    appRouter.go(AppRoutes.search);
    await tester.pumpWidget(SijilakApp(locale: locale));
    await settle(tester);
  } finally {
    resetPlatform();
  }
}

/// The search screen with a query typed and the keyboard open, in both
/// languages: the results scroll instead of overflowing.
void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final device in _devices) {
      final where = '${locale.languageCode} on ${device.name}';

      testWidgets('results with the keyboard open fit, $where', (tester) async {
        await _open(tester, device, locale, const []);
        tester.view.viewInsets = FakeViewPadding(
          bottom:
              device.size.height *
              tester.view.devicePixelRatio *
              _keyboardShare,
        );
        await tester.pump();
        await tester.enterText(find.byType(TextField), _everything);
        await tester.pump(const Duration(milliseconds: 300));
        await settle(tester);

        expect(find.byType(CustomerHitRow), findsWidgets);
        expect(tester.takeException(), isNull);

        await tester.drag(find.byType(ListView).first, const Offset(0, -400));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });

      testWidgets('recent searches and no-results fit, $where', (tester) async {
        await _open(tester, device, locale, ['a', 'b', 'c', 'd', 'e', 'f']);
        expect(tester.takeException(), isNull);

        tester.view.viewInsets = FakeViewPadding(
          bottom:
              device.size.height *
              tester.view.devicePixelRatio *
              _keyboardShare,
        );
        await tester.pump();
        await tester.enterText(find.byType(TextField), 'zzzz');
        await tester.pump(const Duration(milliseconds: 300));
        await settle(tester);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
