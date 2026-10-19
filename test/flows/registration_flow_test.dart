import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/constants/app_config.dart';
import 'package:sijilak/features/auth/presentation/constants/auth_rules.dart';
import 'package:sijilak/features/auth/presentation/widgets/otp_keypad.dart';

import '../helpers/flow_helpers.dart';

const _handle = 'acme-trading';

/// Opens the first registration step from the welcome screen.
Future<void> _startRegistration(WidgetTester tester) async {
  await bootApp(tester);
  await tapText(tester, l10n.createCompanyAccountFree);
  expect(find.text(l10n.companyTitle), findsOneWidget);
}

/// Types [handle] into the workspace link field and waits for the check.
Future<void> _typeHandle(WidgetTester tester, String handle) async {
  await enterByLabel(tester, l10n.workspaceLink, handle);
  await waitFor(tester, AuthRules.handleDebounce);
}

/// Presses the digits of [code] on the on-screen keypad.
Future<void> _pressKeypad(WidgetTester tester, String code) async {
  for (final digit in code.split('')) {
    final key = find.descendant(
      of: find.byType(OtpKeypad),
      matching: find.text(arabicDigit(digit)),
    );
    await tester.tap(key);
    await tester.pump();
  }
}

bool _termsAccepted(WidgetTester tester) =>
    tester.widget<Checkbox>(find.byType(Checkbox)).value!;

void main() {
  testWidgets(
    'registration: company -> account -> otp -> tax -> brand -> done',
    (tester) async {
      await _startRegistration(tester);

      // Step 1: company with an available link.
      await enterByLabel(tester, l10n.companyName, 'شركة أكمي للتجارة');
      await _typeHandle(tester, _handle);
      expect(find.text(l10n.linkAvailable), findsOneWidget);
      await tapText(tester, l10n.continueLabel);

      // Step 2: owner account; the terms must be accepted to continue.
      expect(find.text(l10n.accountTitle), findsOneWidget);
      await enterByLabel(tester, l10n.fullName, 'سارة الأحمد');
      await enterByLabel(tester, l10n.workEmail, 'sara@acme.sa');
      await enterByLabel(tester, l10n.mobileNumber, '512345678');
      await enterByLabel(tester, l10n.password, 'Str0ng-Passw0rd!');
      // The terms start accepted; withdrawing them blocks the next step.
      expect(_termsAccepted(tester), isTrue);
      await tapFinder(tester, find.byType(Checkbox));
      expect(_termsAccepted(tester), isFalse);
      await tapText(tester, l10n.sendOtp);
      expect(find.text(l10n.accountTitle), findsOneWidget);
      await tapFinder(tester, find.byType(Checkbox));
      expect(_termsAccepted(tester), isTrue);

      await tapText(tester, l10n.sendOtp);
      // Step 3: one-time code from the keypad.
      expect(find.text(l10n.verifyAndContinue), findsOneWidget);
      await _pressKeypad(tester, '123456');
      await tapText(tester, l10n.verifyAndContinue);

      // Step 4: tax details can be left for later.
      expect(find.text(l10n.taxTitle), findsOneWidget);
      await tapText(tester, l10n.continueLabel);

      // Step 5: brand, then the workspace is created.
      expect(find.text(l10n.companyLogo), findsWidgets);
      await tapText(tester, l10n.createWorkspace);

      // Done: the workspace link is shown.
      expect(find.text(l10n.workspaceReady), findsOneWidget);
      expect(
        find.textContaining(AppConfig.workspaceUrl(_handle)),
        findsOneWidget,
      );
      expect(find.text(l10n.enterWorkspace), findsOneWidget);
    },
  );

  testWidgets('registration: a reserved handle blocks continue', (
    tester,
  ) async {
    await _startRegistration(tester);

    await _typeHandle(tester, 'admin');
    expect(find.text(l10n.linkTaken), findsOneWidget);
    expect(find.text(l10n.linkAvailable), findsNothing);

    await tapText(tester, l10n.continueLabel);
    expect(find.text(l10n.companyTitle), findsOneWidget);
    expect(find.text(l10n.accountTitle), findsNothing);

    // A free handle lifts the block.
    await _typeHandle(tester, _handle);
    await tapText(tester, l10n.continueLabel);
    expect(find.text(l10n.accountTitle), findsOneWidget);
  });
}
