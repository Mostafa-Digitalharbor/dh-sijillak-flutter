import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/app/widgets/nav_item.dart';
import 'package:sijilak/features/pipeline/presentation/widgets/stage_chip.dart';

import '../helpers/flow_helpers.dart';

const _newDealTitle = 'مشروع اختبار';
const _quotedDealTitle = 'عرض اختبار';

/// Opens a bottom-navigation destination.
Future<void> _openTab(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(NavItem, label));
  await settle(tester);
}

/// The chip of [stage]. The strip lazily builds only the chips near the
/// viewport, so it is scrolled to whichever end holds the chip.
Future<Finder> _stageChip(WidgetTester tester, String stage) async {
  final chip = find.widgetWithText(StageChip, stage);
  final strip = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axis == Axis.horizontal,
  );
  final position = tester.state<ScrollableState>(strip.first).position;
  for (final offset in [position.minScrollExtent, position.maxScrollExtent]) {
    if (chip.evaluate().isNotEmpty) break;
    position.jumpTo(offset);
    await tester.pump();
  }
  return chip;
}

/// Taps the stage chip named [stage].
Future<void> _selectStage(WidgetTester tester, String stage) async {
  await tester.tap(await _stageChip(tester, stage));
  await settle(tester);
}

/// Expects the chip of [stage] to show [count] deals.
Future<void> _expectStageCount(
  WidgetTester tester,
  String stage,
  int count,
) async {
  expect(
    find.descendant(
      of: await _stageChip(tester, stage),
      matching: find.text(arabicAmount(count)),
    ),
    findsOneWidget,
    reason: 'deals in "$stage"',
  );
}

/// Fills and saves the new-deal form through the button named [saveLabel].
Future<void> _createDeal(
  WidgetTester tester, {
  required String title,
  required String value,
  required String saveLabel,
}) async {
  await tapIconButton(tester, l10n.newDeal);
  await enterByLabel(tester, l10n.dealTitle, title);
  await enterByLabel(tester, l10n.expectedValue, value);
  await tapText(tester, saveLabel);
}

void main() {
  testWidgets('sales cycle: lead -> quote -> invoice -> payment -> won', (
    tester,
  ) async {
    await bootApp(tester);
    await signIn(tester);

    // Pipeline: the seeded deals per stage.
    await _openTab(tester, l10n.navPipeline);
    await _expectStageCount(tester, l10n.stageQualified, 5);
    await _expectStageCount(tester, l10n.stageWon, 9);

    // A new lead is saved and shows up in its stage.
    await _createDeal(
      tester,
      title: _newDealTitle,
      value: '12000',
      saveLabel: l10n.saveDeal,
    );
    await _expectStageCount(tester, l10n.stageQualified, 6);
    await _selectStage(tester, l10n.stageQualified);
    expect(find.text(_newDealTitle), findsOneWidget);

    // Save and create a quote: the quote screen opens.
    await _createDeal(
      tester,
      title: _quotedDealTitle,
      value: '5000',
      saveLabel: l10n.saveAndCreateQuote,
    );
    // It is a NEW quote (after the seeded 142) for the deal just created.
    expect(find.text(l10n.quoteNo(arabicAmount(143))), findsOneWidget);
    expect(find.text(l10n.quoteNo(arabicAmount(142))), findsNothing);
    expect(find.text(_quotedDealTitle), findsWidgets);
    expect(find.text('توريد خط تعبئة'), findsNothing);
    expect(find.text(arabicAmount(5000)), findsWidgets);
    expect(
      find.text(l10n.amountSar(arabicAmount(750))),
      findsOneWidget,
      reason: 'VAT',
    );
    expect(
      find.text(l10n.amountSar(arabicAmount(5750))),
      findsOneWidget,
      reason: 'total',
    );
    expect(find.text(l10n.convertToInvoice), findsNothing);

    // The customer approves, which unlocks the conversion.
    await tapText(tester, l10n.customerApprovedConfirm);
    expect(find.text(l10n.customerApprovedConfirm), findsNothing);
    await tapText(tester, l10n.convertToInvoice);

    // The draft invoice carries the quote lines.
    expect(find.text(l10n.newInvoice), findsOneWidget);
    expect(find.text(_quotedDealTitle), findsWidgets);
    expect(find.text('خط تعبئة آلي'), findsNothing);
    await tapText(tester, l10n.issueInvoice);

    // Invoice detail: record the payment in the sheet.
    expect(find.text(l10n.recordPayment), findsOneWidget);
    await tapText(tester, l10n.recordPayment);
    await tapText(tester, l10n.confirmPaymentReceived);

    // Payment done screen: shows what was paid.
    expect(find.text(l10n.paymentRecorded), findsOneWidget);
    expect(find.text(l10n.paidInFull), findsOneWidget);
    expect(find.text(arabicAmount(5750)), findsOneWidget);

    // Back in the pipeline the NEW deal is won; the seeded quoted deal is not.
    await tapText(tester, l10n.backToInvoices);
    await _openTab(tester, l10n.navPipeline);
    await _expectStageCount(tester, l10n.stageWon, 10);
    await _selectStage(tester, l10n.stageWon);
    expect(find.text(_quotedDealTitle), findsOneWidget);
    expect(find.text('توريد خط تعبئة'), findsNothing);
  });
}
