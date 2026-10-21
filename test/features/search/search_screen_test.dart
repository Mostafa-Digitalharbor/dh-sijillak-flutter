import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/app/app.dart';
import 'package:sijilak/app/di/injection.dart';
import 'package:sijilak/core/routing/app_router.dart';
import 'package:sijilak/core/routing/app_routes.dart';
import 'package:sijilak/features/home/presentation/widgets/home_search_field.dart';
import 'package:sijilak/features/search/data/repositories/search_preferences_keys.dart';
import 'package:sijilak/features/search/presentation/widgets/customer_hit_row.dart';
import 'package:sijilak/features/search/presentation/widgets/deal_hit_row.dart';
import 'package:sijilak/features/search/presentation/widgets/invoice_hit_row.dart';
import 'package:sijilak/features/search/presentation/widgets/quote_hit_row.dart';
import 'package:sijilak/features/search/presentation/widgets/recent_search_row.dart';
import 'package:sijilak/l10n/gen/app_localizations.dart';
import 'package:sijilak/l10n/gen/app_localizations_ar.dart';
import 'package:sijilak/l10n/gen/app_localizations_en.dart';

import '../../helpers/pump_route.dart';
import '../../helpers/test_dependencies.dart';

const _device = DeviceSpec('phone', Size(390, 844));
const _debounce = Duration(milliseconds: 300);

/// Matches customers, deals, invoices and quotes of "Modern Food Factory".
const _foods = 'الأغذية';

/// Boots the real app on [route] with the mock backend.
Future<void> _boot(
  WidgetTester tester,
  String route, {
  Locale locale = const Locale('ar'),
  List<String> recents = const [],
}) async {
  applyDevice(tester, _device);
  await loadAppFonts();
  SharedPreferences.setMockInitialValues({
    if (recents.isNotEmpty) SearchPreferencesKeys.recent: recents,
  });
  await configureTestDependencies();
  try {
    appRouter.go(route);
    await tester.pumpWidget(SijilakApp(locale: locale));
    await settle(tester);
  } finally {
    resetPlatform();
  }
}

/// Types [text] into the query box and waits for the results to land.
Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pump(_debounce);
  await settle(tester);
}

String get _path =>
    appRouter.routerDelegate.currentConfiguration.matches.last.matchedLocation;

/// The extra the top-most page was pushed with.
Object? get _extra {
  final configuration = appRouter.routerDelegate.currentConfiguration;
  final top = configuration.matches.last;
  return top is ImperativeRouteMatch ? top.matches.extra : configuration.extra;
}

List<String> _stored() =>
    getIt<SharedPreferences>().getStringList(SearchPreferencesKeys.recent) ??
    const [];

Future<void> _tapRow(WidgetTester tester, Finder row) async {
  await tester.ensureVisible(row);
  await tester.pump();
  await tester.tap(row);
  await settle(tester);
}

void main() {
  final ar = AppLocalizationsAr();
  final en = AppLocalizationsEn();

  group('idle', () {
    testWidgets('shows a friendly hint when nothing was searched', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.search);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text(ar.searchIdleTitle), findsOneWidget);
      expect(find.text(ar.searchIdleHint), findsOneWidget);
      expect(find.text(ar.searchRecentTitle), findsNothing);
    });

    testWidgets('the query box is focused on arrival', (tester) async {
      await _boot(tester, AppRoutes.search);

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue);
    });

    testWidgets('lists the recent searches, most recent first', (tester) async {
      await _boot(tester, AppRoutes.search, recents: ['ثانياً', 'أولاً']);

      expect(find.text(ar.searchRecentTitle), findsOneWidget);
      expect(find.text(ar.searchClearRecent), findsOneWidget);
      final rows = find.byType(RecentSearchRow);
      expect(rows, findsNWidgets(2));
      expect(
        tester.getTopLeft(find.text('ثانياً')).dy,
        lessThan(tester.getTopLeft(find.text('أولاً')).dy),
      );
    });

    testWidgets('tapping a recent search fills the box and searches', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.search, recents: [_foods]);

      await _tapRow(tester, find.byType(RecentSearchRow));

      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        _foods,
      );
      expect(find.byType(CustomerHitRow), findsOneWidget);
      expect(find.byType(RecentSearchRow), findsNothing);
    });

    testWidgets('clear forgets the recent searches', (tester) async {
      await _boot(tester, AppRoutes.search, recents: ['a', 'b']);

      await tester.tap(find.text(ar.searchClearRecent));
      await settle(tester);

      expect(find.byType(RecentSearchRow), findsNothing);
      expect(find.text(ar.searchIdleTitle), findsOneWidget);
      expect(_stored(), isEmpty);
    });

    testWidgets('emptying the box returns to the recent searches', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.search, recents: ['a']);
      await _type(tester, _foods);
      expect(find.byType(RecentSearchRow), findsNothing);

      await _type(tester, '');

      expect(find.byType(RecentSearchRow), findsOneWidget);
      expect(find.byType(CustomerHitRow), findsNothing);
    });
  });

  group('results', () {
    testWidgets('typing shows the matches grouped with counts (ar)', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.search);
      await _type(tester, _foods);

      expect(
        find.text(ar.searchSectionHeading(ar.navCustomers, '١')),
        findsOneWidget,
      );
      expect(
        find.text(ar.searchSectionHeading(ar.navPipeline, '٢')),
        findsOneWidget,
      );
      expect(
        find.text(ar.searchSectionHeading(ar.invoices, '٣')),
        findsOneWidget,
      );
      expect(
        find.text(ar.searchSectionHeading(ar.searchGroupQuotes, '١')),
        findsOneWidget,
      );
      expect(find.byType(CustomerHitRow), findsOneWidget);
      expect(find.byType(DealHitRow), findsNWidgets(2));
      expect(find.byType(InvoiceHitRow), findsNWidgets(3));
      expect(find.byType(QuoteHitRow), findsOneWidget);
      expect(find.text(ar.invoiceNo('٣٩٢')), findsOneWidget);
      expect(find.text(ar.quoteNo('١٤٢')), findsOneWidget);
    });

    testWidgets('the wording follows the locale (en)', (tester) async {
      await _boot(tester, AppRoutes.search, locale: const Locale('en'));
      await _type(tester, '392');

      expect(
        find.text(en.searchSectionHeading(en.invoices, '1')),
        findsOneWidget,
      );
      expect(find.text(en.invoiceNo('392')), findsOneWidget);
      expect(find.text(en.statusPaid), findsOneWidget);
      expect(find.byType(CustomerHitRow), findsNothing);
    });

    testWidgets('Arabic digits find the same invoice as Latin ones', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.search);
      await _type(tester, '٣٩٢');

      expect(find.byType(InvoiceHitRow), findsOneWidget);
      expect(find.text(ar.invoiceNo('٣٩٢')), findsOneWidget);
    });

    testWidgets('a query without matches names what was typed', (tester) async {
      await _boot(tester, AppRoutes.search);
      await _type(tester, 'zzzz');

      expect(find.text(ar.searchNoResultsTitle('zzzz')), findsOneWidget);
      expect(find.text(ar.searchNoResultsHint), findsOneWidget);
      expect(find.byType(CustomerHitRow), findsNothing);
    });

    testWidgets('the no-results message follows the locale (en)', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.search, locale: const Locale('en'));
      await _type(tester, 'zzzz');

      expect(find.text(en.searchNoResultsTitle('zzzz')), findsOneWidget);
    });
  });

  group('opening a result', () {
    final targets = <String, (Type, String, Object)>{
      'a customer opens the profile': (
        CustomerHitRow,
        AppRoutes.customer,
        'c-modern-foods',
      ),
      'a deal opens its customer': (
        DealHitRow,
        AppRoutes.customer,
        'c-modern-foods',
      ),
      'an invoice opens the invoice': (InvoiceHitRow, AppRoutes.invoice, 392),
      'a quote opens the quote': (QuoteHitRow, AppRoutes.quote, 142),
    };

    for (final MapEntry(key: name, value: (row, route, extra))
        in targets.entries) {
      testWidgets('$name and remembers the query', (tester) async {
        await _boot(tester, AppRoutes.search);
        await _type(tester, _foods);

        await _tapRow(tester, find.byType(row).first);

        expect(_path, route);
        expect(_extra, extra);
        expect(_stored(), [_foods]);
      });
    }

    testWidgets('coming back keeps the results and lists the new recent', (
      tester,
    ) async {
      await _boot(tester, AppRoutes.home);
      await tester.tap(find.byType(HomeSearchField));
      await settle(tester);
      await _type(tester, _foods);
      await _tapRow(tester, find.byType(QuoteHitRow));
      expect(_path, AppRoutes.quote);

      appRouter.pop();
      await settle(tester);

      expect(_path, AppRoutes.search);
      expect(find.byType(QuoteHitRow), findsOneWidget);
      await _type(tester, '');
      expect(find.text(_foods), findsOneWidget);
      expect(find.byType(RecentSearchRow), findsOneWidget);
    });

    testWidgets('searching again moves the query to the top', (tester) async {
      await _boot(tester, AppRoutes.search, recents: ['old', _foods]);

      await _tapRow(tester, find.text(_foods));
      await _tapRow(tester, find.byType(InvoiceHitRow).first);

      expect(_stored(), [_foods, 'old']);
    });
  });

  group('home', () {
    for (final (locale, AppLocalizations l10n) in [
      (const Locale('ar'), ar),
      (const Locale('en'), en),
    ]) {
      testWidgets('the search pill opens the search (${locale.languageCode})', (
        tester,
      ) async {
        await _boot(tester, AppRoutes.home, locale: locale);

        expect(find.byType(TextField), findsNothing);
        expect(
          find.bySemanticsLabel(l10n.search),
          findsWidgets,
          reason: 'the pill is a labelled button',
        );
        await tester.tap(find.byType(HomeSearchField));
        await settle(tester);

        expect(_path, AppRoutes.search);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text(l10n.searchIdleTitle), findsOneWidget);
      });
    }

    testWidgets('the back button returns to the dashboard', (tester) async {
      await _boot(tester, AppRoutes.home);
      await tester.tap(find.byType(HomeSearchField));
      await settle(tester);

      await tester.tap(find.bySemanticsLabel(ar.back));
      await settle(tester);

      expect(_path, AppRoutes.home);
    });
  });
}
