import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/entities/app_user.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/entities/workspace.dart';

const _session = AuthSession(
  user: AppUser(id: 'u', name: 'Sara', email: 's@a.sa'),
  workspace: Workspace(
    id: 'w',
    name: 'Acme',
    handle: 'acme',
    url: 'acme.sijillak.com',
  ),
);

const _protected = [
  AppRoutes.home,
  AppRoutes.pipeline,
  AppRoutes.invoices,
  AppRoutes.customer,
  AppRoutes.newLead,
  AppRoutes.quote,
  AppRoutes.newInvoice,
  AppRoutes.invoice,
  AppRoutes.paymentDone,
  AppRoutes.account,
];

const _guest = [AppRoutes.welcome, AppRoutes.login];

const _registration = [
  AppRoutes.regCompany,
  AppRoutes.regAccount,
  AppRoutes.regOtp,
  AppRoutes.regTax,
  AppRoutes.regBrand,
  AppRoutes.regDone,
];

/// Resolves [path] through a fresh router's redirect logic (no screens are
/// built) and returns the location it ends up at.
Future<String> _landing(
  WidgetTester tester, {
  required String path,
  required bool signedIn,
  bool requireAuth = true,
}) async {
  final store = InMemorySessionStore();
  if (signedIn) store.save(_session);
  await tester.pumpWidget(const SizedBox());
  final router = createAppRouter(sessionStore: store, requireAuth: requireAuth);
  addTearDown(router.dispose);
  final matches = await router.routeInformationParser
      .parseRouteInformationWithDependencies(
        RouteInformation(uri: Uri.parse(path)),
        tester.element(find.byType(SizedBox)),
      );
  return matches.uri.path;
}

void main() {
  group('signed out', () {
    for (final path in _protected) {
      testWidgets('$path redirects to welcome', (tester) async {
        expect(
          await _landing(tester, path: path, signedIn: false),
          AppRoutes.welcome,
        );
      });
    }
    for (final path in [..._guest, ..._registration]) {
      testWidgets('$path stays', (tester) async {
        expect(await _landing(tester, path: path, signedIn: false), path);
      });
    }
  });

  group('signed in', () {
    for (final path in _guest) {
      testWidgets('$path redirects to home', (tester) async {
        expect(
          await _landing(tester, path: path, signedIn: true),
          AppRoutes.home,
        );
      });
    }
    for (final path in _protected) {
      testWidgets('$path stays', (tester) async {
        expect(await _landing(tester, path: path, signedIn: true), path);
      });
    }
  });

  group('requireAuth false never redirects', () {
    for (final signedIn in [false, true]) {
      for (final path in [..._protected, ..._guest]) {
        testWidgets('$path (signedIn: $signedIn)', (tester) async {
          expect(
            await _landing(
              tester,
              path: path,
              signedIn: signedIn,
              requireAuth: false,
            ),
            path,
          );
        });
      }
    }
  });
}
