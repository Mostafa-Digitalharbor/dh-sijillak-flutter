import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_routes.dart';

import '../helpers/pump_route.dart';

const _routes = [
  AppRoutes.home,
  AppRoutes.pipeline,
  AppRoutes.customer,
  AppRoutes.newLead,
];

/// The home, pipeline and customer screens in English (LTR) on every device.
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
