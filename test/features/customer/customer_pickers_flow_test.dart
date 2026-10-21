import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_deals_use_case.dart';
import 'package:sijilak/features/customer/domain/usecases/get_customer_invoices_use_case.dart';
import 'package:sijilak/features/home/presentation/widgets/quick_action.dart';
import 'package:sijilak/shared/widgets/picker_tile.dart';
import 'package:sijilak/shared/widgets/primary_button.dart';

import '../../helpers/flow_helpers.dart';
import '../../helpers/pump_route.dart';

const _golden = 'مجموعة العقارات الذهبية';
const _goldenId = 'c-golden-realty';
const _goldenDeal = 'اشتراك برمجيات ١٢ شهراً';
const _goldenLocation = 'جدة · قطاع العقارات';
const _modern = 'مصنع الأغذية الحديثة';
const _modernDeal = 'توريد خط تعبئة';
const _modernWonDeal = 'توريد معدات';
const _united = 'مؤسسة التوريدات المتحدة';
const _unitedId = 'c-united-supplies';
const _unitedLocation = 'جدة · قطاع التجارة والتوزيع';
const _noor = 'شركة النور للتجارة';
const _noorId = 'c-noor-trading';
const _newCustomer = 'شركة الأفق الجديد';

/// Opens the home screen on the flow phone.
Future<void> _openHome(WidgetTester tester) =>
    pumpRoute(tester, AppRoutes.home, flowDevice);

/// Taps the home quick action labelled [label], scrolled into view.
Future<void> _quickAction(WidgetTester tester, String label) async {
  final action = find.widgetWithText(QuickAction, label);
  await tester.scrollUntilVisible(
    action,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tapFinder(tester, action);
}

/// The picker row showing [text] (the screen behind a sheet may show the
/// same text).
Finder _row(String text) =>
    find.descendant(of: find.byType(PickerTile), matching: find.text(text));

/// Pushes [route] on top of the current screen, as a button would.
Future<void> _push(WidgetTester tester, String route, {Object? extra}) async {
  appRouter.push(route, extra: extra);
  await settle(tester);
}

/// Whether the primary button labelled [label] is enabled.
bool _enabled(WidgetTester tester, String label) => tester
    .widget<PrimaryButton>(find.widgetWithText(PrimaryButton, label))
    .enabled;

void main() {
  group('customer picker', () {
    testWidgets('lists every customer and a new-customer entry', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);

      expect(find.text(l10n.customerPickerTitle), findsOneWidget);
      expect(find.text(l10n.newCustomerAction), findsOneWidget);
      for (final name in [_modern, _united, _golden, _noor]) {
        expect(_row(name), findsOneWidget, reason: name);
      }
    });

    testWidgets('searching narrows the list', (tester) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);

      await enterByHint(tester, l10n.customersSearchHint, 'الذهبية');
      await waitFor(tester, const Duration(milliseconds: 400));

      expect(_row(_golden), findsOneWidget);
      expect(_row(_modern), findsNothing);

      await enterByHint(tester, l10n.customersSearchHint, 'zzz');
      await waitFor(tester, const Duration(milliseconds: 400));

      expect(find.text(l10n.customersNoResults), findsOneWidget);
    });
  });

  group('new customer sheet', () {
    testWidgets('saving is disabled until the name is filled', (tester) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.customer);

      expect(find.text(l10n.newCustomerTitle), findsOneWidget);
      expect(_enabled(tester, l10n.newCustomerSave), isFalse);

      await enterByLabel(tester, l10n.newCustomerNameLabel, '   ');
      expect(_enabled(tester, l10n.newCustomerSave), isFalse);

      await enterByLabel(tester, l10n.newCustomerNameLabel, _newCustomer);
      expect(_enabled(tester, l10n.newCustomerSave), isTrue);
    });

    testWidgets('a server rejection is shown and the sheet stays open', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.customer);
      await enterByLabel(tester, l10n.newCustomerNameLabel, _newCustomer);
      await enterByLabel(tester, l10n.email, 'not-an-email');

      await tapText(tester, l10n.newCustomerSave);

      expect(find.text(l10n.errorValidation), findsWidgets);
      expect(find.text(l10n.newCustomerTitle), findsOneWidget);
      expect(_enabled(tester, l10n.newCustomerSave), isTrue);
    });

    testWidgets('the home customer action opens the created profile', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.customer);
      await enterByLabel(tester, l10n.newCustomerNameLabel, _newCustomer);
      await enterByLabel(tester, l10n.city, 'الرياض');

      await tapText(tester, l10n.newCustomerSave);

      expect(find.text(l10n.newCustomerTitle), findsNothing);
      expect(find.text(_newCustomer), findsWidgets);
      expect(find.text(l10n.customerProfile), findsOneWidget);
    });
  });

  group('deal picker', () {
    testWidgets('lists the open deals of the chosen customer', (tester) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);
      await tapFinder(tester, _row(_modern));

      expect(find.text(l10n.dealPickerTitle), findsOneWidget);
      expect(_row(_modernDeal), findsOneWidget);
      expect(find.text(l10n.amountSar(arabicAmount(65000))), findsOneWidget);
      expect(_row(l10n.quote), findsOneWidget);
      expect(find.text(_modernWonDeal), findsNothing, reason: 'won is closed');
      expect(find.text(l10n.dealPickerNew), findsOneWidget);
    });

    testWidgets('a customer without deals only offers a new one', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);
      await tapFinder(tester, _row(_noor));

      expect(find.text(l10n.dealPickerEmpty), findsOneWidget);
      expect(find.text(l10n.dealPickerNew), findsOneWidget);
    });
  });

  group('home quote action', () {
    testWidgets('opens the quote of the picked deal, not the demo one', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);
      await tapFinder(tester, _row(_golden));
      await tapFinder(tester, _row(_goldenDeal));

      expect(find.text(l10n.quoteNo(arabicAmount(143))), findsOneWidget);
      expect(find.text(l10n.quoteNo(arabicAmount(142))), findsNothing);
      expect(find.text(_golden), findsWidgets);
      expect(find.text(_goldenDeal), findsWidgets);
    });

    testWidgets('a deal that already has a quote opens that quote', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);
      await tapFinder(tester, _row(_modern));
      await tapFinder(tester, _row(_modernDeal));

      expect(find.text(l10n.quoteNo(arabicAmount(142))), findsOneWidget);
    });

    testWidgets('choosing a new deal opens the form for that customer', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);
      await tapFinder(tester, _row(_golden));
      await tapText(tester, l10n.dealPickerNew);

      expect(find.text(l10n.newDeal), findsOneWidget);
      expect(find.text(_golden), findsOneWidget);
      expect(find.text(_goldenLocation), findsOneWidget);
    });

    testWidgets('a customer created in the picker continues to its deals', (
      tester,
    ) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);
      await tapText(tester, l10n.newCustomerAction);
      await enterByLabel(tester, l10n.newCustomerNameLabel, _newCustomer);
      await tapText(tester, l10n.newCustomerSave);

      expect(find.text(l10n.dealPickerTitle), findsOneWidget);
      expect(find.text(l10n.dealPickerEmpty), findsOneWidget);
    });

    testWidgets('dismissing the picker does nothing', (tester) async {
      await _openHome(tester);
      await _quickAction(tester, l10n.quote);

      await tester.tapAt(const Offset(195, 40));
      await settle(tester);

      expect(find.text(l10n.customerPickerTitle), findsNothing);
      expect(find.text(l10n.dealPickerTitle), findsNothing);
    });
  });

  group('customer profile quote button', () {
    testWidgets('a customer with open deals picks one directly', (
      tester,
    ) async {
      await _openHome(tester);
      await _push(tester, AppRoutes.customer, extra: _goldenId);

      await tapText(tester, l10n.quote);

      expect(find.text(l10n.customerPickerTitle), findsNothing);
      expect(find.text(l10n.dealPickerTitle), findsOneWidget);
      await tapFinder(tester, _row(_goldenDeal));
      expect(find.text(l10n.quoteNo(arabicAmount(143))), findsOneWidget);
    });

    testWidgets('a customer without open deals goes to the new deal form', (
      tester,
    ) async {
      await _openHome(tester);
      await _push(tester, AppRoutes.customer, extra: _noorId);

      await tapText(tester, l10n.quote);

      expect(find.text(l10n.dealPickerTitle), findsNothing);
      expect(find.text(l10n.newDeal), findsOneWidget);
      expect(find.text(_noor), findsOneWidget);
    });

    testWidgets('the new deal for such a customer can be saved', (
      tester,
    ) async {
      await _openHome(tester);
      await _push(tester, AppRoutes.customer, extra: _noorId);
      await tapText(tester, l10n.quote);
      await enterByLabel(tester, l10n.dealTitle, 'صفقة النور');
      await enterByLabel(tester, l10n.expectedValue, '7000');

      await tapText(tester, l10n.saveAndCreateQuote);

      expect(find.text(l10n.quoteNo(arabicAmount(143))), findsOneWidget);
      final deals = (await getIt<GetCustomerDealsUseCase>()(_noorId))
          .dataOrNull!;
      expect(deals.single.title, 'صفقة النور');
    });
  });

  group('new lead customer', () {
    testWidgets('starts with the default customer', (tester) async {
      await pumpRoute(tester, AppRoutes.newLead, flowDevice);

      expect(find.text(_modern), findsOneWidget);
    });

    testWidgets('tapping the customer picks another one for the deal', (
      tester,
    ) async {
      await _openHome(tester);
      await _push(tester, AppRoutes.newLead);

      await tapText(tester, _modern);
      expect(find.text(l10n.customerPickerTitle), findsOneWidget);
      await tapFinder(tester, _row(_united));

      expect(find.text(l10n.customerPickerTitle), findsNothing);
      expect(find.text(_united), findsOneWidget);
      expect(find.text(_unitedLocation), findsOneWidget);
      expect(find.text(_modern), findsNothing);

      await enterByLabel(tester, l10n.dealTitle, 'صفقة المتحدة');
      await enterByLabel(tester, l10n.expectedValue, '3000');
      await tapText(tester, l10n.saveDeal);

      final deals = (await getIt<GetCustomerDealsUseCase>()(_unitedId))
          .dataOrNull!;
      expect(deals.map((d) => d.title), contains('صفقة المتحدة'));
    });

    testWidgets('the new customer action selects the created customer', (
      tester,
    ) async {
      await _openHome(tester);
      await _push(tester, AppRoutes.newLead);

      await tapText(tester, l10n.newCustomerAction);
      await enterByLabel(tester, l10n.newCustomerNameLabel, _newCustomer);
      await tapText(tester, l10n.newCustomerSave);

      expect(find.text(l10n.newCustomerTitle), findsNothing);
      expect(find.text(_newCustomer), findsOneWidget);
      expect(find.text(_modern), findsNothing);
    });
  });

  group('new invoice customer', () {
    testWidgets('the change action bills another customer', (tester) async {
      await pumpRoute(tester, AppRoutes.newInvoice, flowDevice);

      await tapText(tester, l10n.change);
      expect(find.text(l10n.customerPickerTitle), findsOneWidget);
      await tapFinder(tester, _row(_golden));

      expect(find.text(l10n.customerPickerTitle), findsNothing);
      expect(find.text(_golden), findsOneWidget);

      await tapText(tester, l10n.issueInvoice);

      final invoices = (await getIt<GetCustomerInvoicesUseCase>()(_goldenId))
          .dataOrNull!;
      expect(invoices.first.number, greaterThan(392));
      final modern = (await getIt<GetCustomerInvoicesUseCase>()(
        'c-modern-foods',
      )).dataOrNull!;
      expect(
        modern.map((i) => i.number),
        isNot(contains(invoices.first.number)),
      );
    });
  });
}
