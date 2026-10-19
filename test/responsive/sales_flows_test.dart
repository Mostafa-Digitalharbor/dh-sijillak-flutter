import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/shared/widgets/glass_icon_button.dart';

import '../helpers/pump_route.dart';

/// Strings of one language used to drive the sales flows.
class _Texts {
  const _Texts({
    required this.addProduct,
    required this.catalog,
    required this.searchHint,
    required this.addToInvoice,
    required this.lastMonth,
    required this.thisMonth,
  });

  final String addProduct;
  final String catalog;
  final String searchHint;
  final String addToInvoice;
  final String lastMonth;
  final String thisMonth;
}

const _ar = _Texts(
  addProduct: 'إضافة منتج',
  catalog: 'من قائمة المنتجات',
  searchHint: 'ابحث برقم الفاتورة أو العميل',
  addToInvoice: 'إضافة إلى الفاتورة',
  lastMonth: 'الشهر الماضي',
  thisMonth: 'هذا الشهر',
);

const _en = _Texts(
  addProduct: 'Add product',
  catalog: 'From the catalog',
  searchHint: 'Search by invoice number or customer',
  addToInvoice: 'Add to invoice',
  lastMonth: 'Last month',
  thisMonth: 'This month',
);

/// Lets the catalog fixture (real asset IO) arrive and the sheet animate in.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 100));
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 150)),
  );
  await tester.pump(const Duration(milliseconds: 500));
}

/// Runs the sheet's slide-out until its route is gone.
Future<void> _closeSheet(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> _openAddProduct(WidgetTester tester, _Texts texts) async {
  // Scroll the button clear of the pinned total bar before tapping it.
  await tester.drag(find.byType(ListView).first, const Offset(0, -400));
  await tester.pump();
  await tester.tap(find.text(texts.addProduct));
  await _settle(tester);
  expect(find.text(texts.catalog), findsOneWidget);
}

void main() {
  for (final (locale, texts) in const [
    (Locale('ar'), _ar),
    (Locale('en'), _en),
  ]) {
    final lang = locale.languageCode;
    for (final device in DeviceSpec.all) {
      testWidgets('add-product sheet ($lang) fits ${device.name}', (
        tester,
      ) async {
        await pumpRoute(tester, AppRoutes.newInvoice, device, locale: locale);
        await _openAddProduct(tester, texts);
        expect(find.text('صيانة دورية'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'add-product sheet ($lang) is keyboard safe on ${device.name}',
        (tester) async {
          await pumpRoute(tester, AppRoutes.newInvoice, device, locale: locale);
          await _openAddProduct(tester, texts);
          tester.view.viewInsets = FakeViewPadding(
            bottom: device.size.height * tester.view.devicePixelRatio * 0.4,
          );
          await tester.pump();
          await tester.tap(find.byType(TextField).first, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets('search field ($lang) fits ${device.name}', (tester) async {
        await pumpRoute(tester, AppRoutes.invoices, device, locale: locale);
        expect(find.text(texts.searchHint), findsNothing);
        await tester.tap(find.byType(GlassIconButton).first);
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text(texts.searchHint), findsOneWidget);
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .focusNode
              .hasFocus,
          isTrue,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('period menu ($lang) fits ${device.name}', (tester) async {
        await pumpRoute(tester, AppRoutes.invoices, device, locale: locale);
        await tester.tap(find.text(texts.thisMonth));
        await tester.pumpAndSettle();
        expect(find.text(texts.lastMonth), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('picking a catalog product adds a line ($lang)', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        AppRoutes.newInvoice,
        DeviceSpec.all[2],
        locale: locale,
      );
      expect(find.text('خط تعبئة آلي'), findsNothing);
      await _openAddProduct(tester, texts);
      await tester.tap(find.text('خط تعبئة آلي'));
      await _closeSheet(tester);
      expect(find.text(texts.catalog), findsNothing);
      expect(find.text('خط تعبئة آلي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a custom item needs a name and a price ($lang)', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        AppRoutes.newInvoice,
        DeviceSpec.all[2],
        locale: locale,
      );
      await _openAddProduct(tester, texts);
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Test item');
      await tester.pump();
      await tester.tap(find.text(texts.addToInvoice), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(texts.catalog), findsOneWidget);

      await tester.enterText(fields.at(1), '1500');
      await tester.pump();
      await tester.ensureVisible(find.text(texts.addToInvoice));
      await tester.tap(find.text(texts.addToInvoice));
      await _closeSheet(tester);
      expect(find.text(texts.catalog), findsNothing);
      expect(find.text('Test item'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('swiping a line away removes it until one is left', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutes.newInvoice, DeviceSpec.all[2]);
    const first = 'توريد معدات تعبئة';
    const second = 'خدمة التركيب والتشغيل';
    expect(find.text(first), findsOneWidget);
    await tester.drag(find.text(first), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text(first), findsNothing);
    expect(find.text(second), findsOneWidget);

    await tester.drag(find.text(second), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text(second), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('choosing last month filters the list and relabels the button', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutes.invoices, DeviceSpec.all[2]);
    expect(find.text('392'), findsNothing);
    await tester.tap(find.text(_ar.thisMonth));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_ar.lastMonth));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 150)),
    );
    await tester.pumpAndSettle();
    expect(find.text(_ar.lastMonth), findsOneWidget);
    expect(find.text(_ar.thisMonth), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
