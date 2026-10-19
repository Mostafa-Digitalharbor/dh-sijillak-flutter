import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/app/widgets/nav_item.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/customer/presentation/constants/customer_constants.dart';

import '../../helpers/flow_helpers.dart';
import '../../helpers/pump_route.dart' show pumpRoute;

const _logistics = 'شركة الخدمات اللوجستية';
const _modernFoods = 'مصنع الأغذية الحديثة';
const _noorId = 'c-noor-trading';

String get _path =>
    appRouter.routerDelegate.currentConfiguration.last.matchedLocation;

/// Opens [route] in the real app on the flow phone.
Future<void> _open(WidgetTester tester, String route) =>
    pumpRoute(tester, route, flowDevice);

/// Types [text] into the open search field and waits out the debounce.
Future<void> _search(WidgetTester tester, String text) async {
  await enterAt(tester, 0, text);
  await waitFor(tester, CustomerConstants.searchDebounce);
}

void main() {
  group('customers list', () {
    testWidgets('shows every customer with its count', (tester) async {
      await _open(tester, AppRoutes.customers);

      expect(find.text(l10n.navCustomers), findsWidgets);
      expect(find.text(l10n.customersCount(arabicDigit('6'))), findsOneWidget);
      expect(find.text(_modernFoods), findsOneWidget);
      expect(find.text(_logistics), findsOneWidget);
      expect(find.text('الرياض · قطاع الصناعة'), findsOneWidget);
      expect(
        find.text(l10n.customerDuePill(l10n.amountSar(arabicAmount(12650)))),
        findsOneWidget,
      );
      expect(
        find.text(l10n.customerOpenDealsCount(arabicDigit('1'))),
        findsWidgets,
      );
    });

    testWidgets('the Customers tab is active in the bottom bar', (
      tester,
    ) async {
      await _open(tester, AppRoutes.customers);

      final item = tester.widget<NavItem>(
        find.widgetWithText(NavItem, l10n.navCustomers),
      );
      expect(item.active, isTrue);
      expect(item.tab.path, AppRoutes.customers);
    });

    testWidgets('the bottom bar tab switches to the list', (tester) async {
      await _open(tester, AppRoutes.home);

      await tester.tap(find.widgetWithText(NavItem, l10n.navCustomers));
      await settle(tester);

      expect(_path, AppRoutes.customers);
      expect(find.text(_modernFoods), findsOneWidget);
    });

    testWidgets('search narrows the list and closing restores it', (
      tester,
    ) async {
      await _open(tester, AppRoutes.customers);

      await tapIconButton(tester, l10n.search);
      await _search(tester, 'اللوجستية');
      expect(find.text(_logistics), findsOneWidget);
      expect(find.text(_modernFoods), findsNothing);
      expect(find.text(l10n.customersCount(arabicDigit('1'))), findsOneWidget);

      await tapIconButton(tester, l10n.closeSearch);
      expect(find.text(_modernFoods), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('a search without matches says so', (tester) async {
      await _open(tester, AppRoutes.customers);

      await tapIconButton(tester, l10n.search);
      await _search(tester, 'zzzz');

      expect(find.text(l10n.customersNoResults), findsOneWidget);
    });

    testWidgets('tapping a row opens that customer profile', (tester) async {
      await _open(tester, AppRoutes.customers);

      await tapText(tester, _logistics);

      expect(_path, AppRoutes.customer);
      expect(find.text(l10n.customerProfile), findsOneWidget);
      expect(find.text(_logistics), findsOneWidget);
      expect(find.text('الرياض · قطاع الخدمات'), findsOneWidget);
    });
  });

  group('customer profile tabs', () {
    testWidgets('without a route extra it shows the featured customer', (
      tester,
    ) async {
      await _open(tester, AppRoutes.customer);

      expect(find.text(_modernFoods), findsOneWidget);
    });

    testWidgets('details lists the contact and account data', (tester) async {
      await _open(tester, AppRoutes.customer);

      await tapText(tester, l10n.tabData);

      for (final label in [
        l10n.mobileNumber,
        l10n.email,
        l10n.customerAddress,
        l10n.city,
        l10n.customerSector,
        l10n.commercialRegNo,
        l10n.vatNumber,
        l10n.customerSince,
        l10n.owner,
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      expect(find.text('+966 11 234 5678'), findsOneWidget);
      expect(find.text('info@modernfoods.sa'), findsOneWidget);
    });

    testWidgets('deals lists the deals of the customer', (tester) async {
      await _open(tester, AppRoutes.customer);

      await tapText(tester, l10n.navPipeline);

      expect(find.text('توريد خط تعبئة'), findsOneWidget);
      expect(find.text('توريد معدات'), findsOneWidget);
      expect(find.text(l10n.stageWon), findsOneWidget);
      expect(find.text(l10n.probabilityPct(arabicDigit('60'))), findsOneWidget);
      expect(find.text('نظام نقاط بيع لفرعين'), findsNothing);
    });

    testWidgets('invoices lists the invoices and opens one', (tester) async {
      await _open(tester, AppRoutes.customer);

      await tapText(tester, l10n.invoices);

      expect(
        find.text(l10n.customerInvoiceTitle(arabicDigit('392'))),
        findsOneWidget,
      );
      expect(
        find.text(l10n.customerInvoiceTitle(arabicDigit('388'))),
        findsOneWidget,
      );
      expect(find.text(l10n.statusLate), findsOneWidget);

      await tapText(tester, l10n.customerInvoiceTitle(arabicDigit('388')));

      expect(_path, AppRoutes.invoice);
    });

    testWidgets('a customer without deals or invoices shows empty states', (
      tester,
    ) async {
      await _open(tester, AppRoutes.home);
      appRouter.push(AppRoutes.customer, extra: _noorId);
      await settle(tester);

      await tapText(tester, l10n.navPipeline);
      expect(find.text(l10n.customerNoDeals), findsOneWidget);

      await tapText(tester, l10n.invoices);
      expect(find.text(l10n.customerNoInvoices), findsOneWidget);
    });
  });
}
