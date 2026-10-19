import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/account/data/repositories/locale_preferences_keys.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/repositories/session_store.dart';
import 'package:sijilak/l10n/gen/app_localizations_ar.dart';
import 'package:sijilak/l10n/gen/app_localizations_en.dart';

import '../../helpers/pump_route.dart';
import 'account_fixtures.dart';

const _device = DeviceSpec('phone', Size(390, 844));

/// Boots the real app, signed in, on the account route with the guarded
/// router, in the language stored under [savedLanguage].
Future<void> _openAccount(WidgetTester tester, String savedLanguage) async {
  applyDevice(tester, _device);
  await loadAppFonts();
  SharedPreferences.setMockInitialValues({
    LocalePreferencesKeys.language: savedLanguage,
  });
  await configureDependencies(latency: Duration.zero);
  getIt<SessionStore>().save(accountSession);
  appRouter = createAppRouter(
    sessionStore: getIt<SessionStore>(),
    requireAuth: true,
  );
  addTearDown(
    () => appRouter = createAppRouter(sessionStore: InMemorySessionStore()),
  );
  appRouter.go(AppRoutes.account);
  await tester.pumpWidget(const SijilakApp());
  await settle(tester);
}

void main() {
  final ar = AppLocalizationsAr();
  final en = AppLocalizationsEn();

  for (final entry in {'ar': ar, 'en': en}.entries) {
    testWidgets('shows the profile, language and sign out (${entry.key})', (
      tester,
    ) async {
      final l10n = entry.value;
      await _openAccount(tester, entry.key);
      expect(find.text(l10n.settingsTitle), findsOneWidget);
      expect(find.text('Sara Ahmed'), findsOneWidget);
      expect(find.text('sara@acme.sa'), findsOneWidget);
      expect(find.text('Acme Trading'), findsOneWidget);
      expect(find.text('acme.sijillak.com'), findsOneWidget);
      expect(find.text(l10n.settingsLanguage), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text(l10n.settingsSignOut), findsOneWidget);
      final direction = entry.key == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr;
      expect(
        Directionality.of(tester.element(find.text('Sara Ahmed'))),
        direction,
      );
    });
  }

  testWidgets('choosing a language switches the app and persists it', (
    tester,
  ) async {
    await _openAccount(tester, 'ar');
    await tester.tap(find.text('English'));
    await settle(tester);
    expect(find.text(en.settingsTitle), findsOneWidget);
    expect(find.text(en.settingsSignOut), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(LocalePreferencesKeys.language), 'en');

    await tester.tap(find.text('العربية'));
    await settle(tester);
    expect(find.text(ar.settingsTitle), findsOneWidget);
    expect(prefs.getString(LocalePreferencesKeys.language), 'ar');
  });

  testWidgets('cancelling the dialog keeps the session', (tester) async {
    await _openAccount(tester, 'en');
    await tester.tap(find.text(en.settingsSignOut));
    await settle(tester);
    expect(find.text(en.settingsSignOutTitle), findsOneWidget);
    expect(find.text(en.settingsSignOutBody), findsOneWidget);

    await tester.tap(find.text(en.settingsCancel));
    await settle(tester);
    expect(find.text(en.settingsSignOutTitle), findsNothing);
    expect(getIt<SessionStore>().current, isNotNull);
    expect(find.text(en.settingsTitle), findsOneWidget);
  });

  testWidgets(
    'confirming signs out, opens welcome and guards protected routes',
    (tester) async {
      await _openAccount(tester, 'en');
      await tester.tap(find.text(en.settingsSignOut));
      await settle(tester);
      // The dialog's confirm button carries the same label as the screen's.
      await tester.tap(find.text(en.settingsSignOutConfirm).last);
      await settle(tester);

      expect(getIt<SessionStore>().current, isNull);
      expect(
        appRouter.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.welcome,
      );

      appRouter.go(AppRoutes.home);
      await settle(tester);
      expect(
        appRouter.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.welcome,
      );
    },
  );
}
