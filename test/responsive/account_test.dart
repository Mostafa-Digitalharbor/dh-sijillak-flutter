import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_routes.dart';

import '../features/account/account_fixtures.dart';
import '../helpers/pump_route.dart';

void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final device in DeviceSpec.all) {
      testWidgets('account (${locale.languageCode}) fits ${device.name}', (
        tester,
      ) async {
        await pumpRoute(
          tester,
          AppRoutes.account,
          device,
          locale: locale,
          session: accountSession,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Acme Trading'), findsOneWidget);
      });
    }
  }
}
