import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/utils/arabic_digits.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/repositories/session_store.dart';
import 'package:sijilak/l10n/gen/app_localizations_ar.dart';
import 'package:sijilak/shared/widgets/glass_icon_button.dart';

import 'pump_route.dart';

export 'pump_route.dart' show settle;

/// Phone-sized surface the user flows run on.
const flowDevice = DeviceSpec('flow phone', Size(390, 844));

/// The Arabic strings the app shows, read from the real localisation class so
/// the flows never hard-code copy.
final l10n = AppLocalizationsAr();

/// Arabic-Indic digits with the Arabic thousands separator, as the app
/// formats money.
String arabicAmount(num value) => value.toArabicAmount;

/// Starts the real app the way `main` does: mock backend with no latency and
/// the session-guarded router, signed out.
Future<void> bootApp(WidgetTester tester) async {
  applyDevice(tester, flowDevice);
  await loadAppFonts();
  SharedPreferences.setMockInitialValues({});
  await configureDependencies(latency: Duration.zero);
  appRouter = createAppRouter(
    sessionStore: getIt<SessionStore>(),
    requireAuth: true,
  );
  addTearDown(
    () => appRouter = createAppRouter(sessionStore: InMemorySessionStore()),
  );
  await tester.pumpWidget(const SijilakApp());
  await settle(tester);
}

/// Taps [target] (scrolled into view first), then lets the app settle.
Future<void> tapFinder(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.tap(target);
  await settle(tester);
}

/// Taps the [index]-th widget showing exactly [text].
Future<void> tapText(WidgetTester tester, String text, {int index = 0}) =>
    tapFinder(tester, find.text(text).at(index));

/// Taps the icon button whose accessibility label is [label].
Future<void> tapIconButton(WidgetTester tester, String label) async {
  final button = find.byWidgetPredicate(
    (w) => w is GlassIconButton && w.label == label,
  );
  await tester.tap(button);
  await settle(tester);
}

/// Types [text] into the text field that sits under the caption [label].
Future<void> enterByLabel(
  WidgetTester tester,
  String label,
  String text,
) async {
  // The caption and its field share the nearest Column above the caption.
  Element? column;
  find.text(label).evaluate().first.visitAncestorElements((ancestor) {
    if (ancestor.widget is! Column) return true;
    column = ancestor;
    return false;
  });
  final field = find.descendant(
    of: find.byElementPredicate((e) => identical(e, column)),
    matching: find.byType(TextField),
  );
  await tester.ensureVisible(field.first);
  await tester.enterText(field.first, text);
  await tester.pump();
}

/// Types [text] into the field showing [hint] while empty.
Future<void> enterByHint(WidgetTester tester, String hint, String text) async {
  final field = find.widgetWithText(TextField, hint);
  await tester.ensureVisible(field.first);
  await tester.enterText(field.first, text);
  await tester.pump();
}

/// Types [text] into the [index]-th text field on screen.
Future<void> enterAt(WidgetTester tester, int index, String text) async {
  await tester.enterText(find.byType(TextField).at(index), text);
  await tester.pump();
}

/// Lets a debounce of [wait] elapse, then the request it triggers finish.
Future<void> waitFor(WidgetTester tester, Duration wait) async {
  await tester.pump(wait);
  await settle(tester);
}

/// Signs in through the welcome and login screens.
Future<void> signIn(
  WidgetTester tester, {
  String email = 'sara@acme.sa',
}) async {
  await tapText(tester, l10n.haveAccountSignIn);
  await enterByLabel(tester, l10n.email, email);
  await enterAt(tester, 1, 'secret123');
  await tapText(tester, l10n.signIn);
}

/// [digit] (0-9) in the numerals the Arabic UI shows.
String arabicDigit(String digit) => digit.toArabicDigits;
