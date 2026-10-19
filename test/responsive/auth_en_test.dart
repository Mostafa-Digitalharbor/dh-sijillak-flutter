import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_routes.dart';

import '../helpers/pump_route.dart';

const _routes = [
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.regCompany,
  AppRoutes.regAccount,
  AppRoutes.regOtp,
  AppRoutes.regTax,
  AppRoutes.regBrand,
  AppRoutes.regDone,
];

/// Welcome, sign-in and registration screens in English on every spec.
void main() {
  for (final route in _routes) {
    for (final device in DeviceSpec.all) {
      testWidgets('$route (en) fits ${device.name}', (tester) async {
        await pumpRoute(tester, route, device, locale: const Locale('en'));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
