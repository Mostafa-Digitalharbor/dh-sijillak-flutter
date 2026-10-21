import 'dart:io';

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
  AppRoutes.home,
  AppRoutes.pipeline,
  AppRoutes.invoices,
  AppRoutes.customer,
  AppRoutes.customers,
  AppRoutes.newLead,
  AppRoutes.quote,
  AppRoutes.newInvoice,
  AppRoutes.invoice,
  AppRoutes.paymentDone,
  AppRoutes.account,
  AppRoutes.notifications,
  AppRoutes.search,
];

/// `ROUTE=/home flutter test test/responsive` limits the run to one route.
final _only = Platform.environment['ROUTE'] ?? '';

void main() {
  for (final route in _routes) {
    if (_only.isNotEmpty && route != _only) continue;
    for (final device in DeviceSpec.all) {
      testWidgets('$route fits ${device.name}', (tester) async {
        await pumpRoute(tester, route, device);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
