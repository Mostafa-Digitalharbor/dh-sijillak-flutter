import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_routes.dart';

import '../helpers/pump_route.dart';

const _routes = [
  AppRoutes.quote,
  AppRoutes.invoices,
  AppRoutes.invoice,
  AppRoutes.newInvoice,
  AppRoutes.paymentDone,
];

/// Quote and invoice screens in English, plus the payment sheet (opened from
/// the invoice) in both languages, on every device spec.
void main() {
  for (final route in _routes) {
    for (final device in DeviceSpec.all) {
      testWidgets('$route (en) fits ${device.name}', (tester) async {
        await pumpRoute(tester, route, device, locale: const Locale('en'));
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final (locale, label, confirm) in const [
    (Locale('ar'), 'تسجيل دفعة', 'تأكيد استلام الدفعة'),
    (Locale('en'), 'Record payment', 'Confirm payment received'),
  ]) {
    for (final device in DeviceSpec.all) {
      testWidgets(
        'payment sheet (${locale.languageCode}) fits ${device.name}',
        (tester) async {
          await pumpRoute(tester, AppRoutes.invoice, device, locale: locale);
          await tester.tap(find.text(label).first);
          await tester.pump(const Duration(milliseconds: 500));
          expect(find.text(confirm), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
