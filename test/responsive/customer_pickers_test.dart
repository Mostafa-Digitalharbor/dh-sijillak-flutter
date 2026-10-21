import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/home/presentation/widgets/quick_action.dart';
import 'package:sijilak/l10n/gen/app_localizations.dart';
import 'package:sijilak/l10n/gen/app_localizations_ar.dart';
import 'package:sijilak/l10n/gen/app_localizations_en.dart';

import '../helpers/pump_route.dart';

/// A customer whose fixture has open deals (the deal picker lists them).
const _customerWithDeals = 'مجموعة العقارات الذهبية';
const _openDeal = 'اشتراك برمجيات ١٢ شهراً';

/// Scroll past the point where an action first scrolls into view.
const _navClear = 150.0;

/// Phone and tablet configurations the picker sheets must fit.
final _devices = DeviceSpec.all.take(6).toList();

Future<void> _tapQuickAction(WidgetTester tester, String label) async {
  final action = find.widgetWithText(QuickAction, label);
  await tester.scrollUntilVisible(
    action,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  // Clear the floating navigation bar that overlays the list bottom.
  await tester.drag(find.byType(Scrollable).first, const Offset(0, -_navClear));
  await tester.pump();
  await tester.tap(action);
  await settle(tester);
}

Future<void> _openCustomerPicker(
  WidgetTester tester,
  AppLocalizations l10n,
) async {
  await _tapQuickAction(tester, l10n.quote);
  expect(find.text(l10n.customerPickerTitle), findsOneWidget);
}

Future<void> _openDealPicker(WidgetTester tester, AppLocalizations l10n) async {
  await _openCustomerPicker(tester, l10n);
  await tester.ensureVisible(find.text(_customerWithDeals));
  await tester.tap(find.text(_customerWithDeals));
  await settle(tester);
  expect(find.text(l10n.dealPickerTitle), findsOneWidget);
}

Future<void> _openNewCustomer(
  WidgetTester tester,
  AppLocalizations l10n,
) async {
  await _tapQuickAction(tester, l10n.customer);
  expect(find.text(l10n.newCustomerTitle), findsOneWidget);
}

/// Raises the keyboard over the bottom 40% of the screen and focuses the
/// first field of the open sheet.
Future<void> _raiseKeyboard(WidgetTester tester, DeviceSpec device) async {
  tester.view.viewInsets = FakeViewPadding(
    bottom: device.size.height * tester.view.devicePixelRatio * 0.4,
  );
  await tester.pump();
  await tester.tap(find.byType(TextField).first, warnIfMissed: false);
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  for (final (locale, l10n) in <(Locale, AppLocalizations)>[
    (const Locale('ar'), AppLocalizationsAr()),
    (const Locale('en'), AppLocalizationsEn()),
  ]) {
    final lang = locale.languageCode;
    for (final device in _devices) {
      testWidgets('customer picker ($lang) fits ${device.name}', (
        tester,
      ) async {
        await pumpRoute(tester, AppRoutes.home, device, locale: locale);
        await _openCustomerPicker(tester, l10n);
        expect(find.text(l10n.newCustomerAction), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'customer picker ($lang) is keyboard safe on ${device.name}',
        (tester) async {
          await pumpRoute(tester, AppRoutes.home, device, locale: locale);
          await _openCustomerPicker(tester, l10n);
          await _raiseKeyboard(tester, device);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets('new customer sheet ($lang) fits ${device.name}', (
        tester,
      ) async {
        await pumpRoute(tester, AppRoutes.home, device, locale: locale);
        await _openNewCustomer(tester, l10n);
        expect(find.text(l10n.newCustomerSave), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'new customer sheet ($lang) is keyboard safe on ${device.name}',
        (tester) async {
          await pumpRoute(tester, AppRoutes.home, device, locale: locale);
          await _openNewCustomer(tester, l10n);
          await _raiseKeyboard(tester, device);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets('deal picker ($lang) fits ${device.name}', (tester) async {
        await pumpRoute(tester, AppRoutes.home, device, locale: locale);
        await _openDealPicker(tester, l10n);
        expect(find.text(_openDeal), findsOneWidget);
        expect(find.text(l10n.dealPickerNew), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
