import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/l10n/gen/app_localizations.dart';
import 'package:sijilak/l10n/gen/app_localizations_ar.dart';
import 'package:sijilak/l10n/gen/app_localizations_en.dart';

import '../helpers/flow_helpers.dart' show tapIconButton;
import '../helpers/pump_route.dart';

const _noorId = 'c-noor-trading';

/// Where in the viewport (0 top, 1 bottom) a tapped tab is scrolled to.
const _tabAlignment = 0.3;

/// Pixels scrolled per step while looking for a tab that is not built yet.
const _scrollStep = 100.0;

/// Devices the profile tabs and the customers list are exercised on: small
/// phone, small phone with large text, and landscape.
final _devices = [DeviceSpec.all[0], DeviceSpec.all[1], DeviceSpec.all[5]];

final _locales = <Locale, AppLocalizations>{
  const Locale('ar'): AppLocalizationsAr(),
  const Locale('en'): AppLocalizationsEn(),
};

/// Scrolls the tab labelled [label] clear of the pinned bar, then taps it.
Future<void> _tapTab(WidgetTester tester, String label) async {
  final target = find.text(label);
  await tester.scrollUntilVisible(
    target,
    _scrollStep,
    scrollable: find
        .descendant(
          of: find.byType(ListView).first,
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await Scrollable.ensureVisible(
    tester.element(target),
    alignment: _tabAlignment,
  );
  await tester.pump();
  await tester.tap(target);
  await settle(tester);
}

/// Every tab of the customer profile (featured customer and one with no
/// deals or invoices), and the customers list with its search open, in both
/// languages.
void main() {
  for (final MapEntry(key: locale, value: l10n) in _locales.entries) {
    for (final device in _devices) {
      final where = '${locale.languageCode} on ${device.name}';

      testWidgets('customer profile tabs fit, $where', (tester) async {
        await pumpRoute(tester, AppRoutes.customer, device, locale: locale);
        expect(tester.takeException(), isNull);

        for (final tab in [
          l10n.invoices,
          l10n.navPipeline,
          l10n.tabData,
          l10n.tabActivity,
        ]) {
          await _tapTab(tester, tab);
          expect(tester.takeException(), isNull, reason: tab);
        }
      });

      testWidgets('empty customer tabs fit, $where', (tester) async {
        await pumpRoute(tester, AppRoutes.home, device, locale: locale);
        appRouter.push(AppRoutes.customer, extra: _noorId);
        await settle(tester);

        for (final tab in [l10n.invoices, l10n.navPipeline, l10n.tabData]) {
          await _tapTab(tester, tab);
          expect(tester.takeException(), isNull, reason: tab);
        }
      });

      testWidgets('customers list with search fits, $where', (tester) async {
        await pumpRoute(tester, AppRoutes.customers, device, locale: locale);
        expect(tester.takeException(), isNull);

        await tapIconButton(tester, l10n.search);
        expect(find.byType(TextField), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'zzzz');
        await tester.pump(const Duration(milliseconds: 400));
        await settle(tester);
        expect(find.text(l10n.customersNoResults), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
