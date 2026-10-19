import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sijilak/features/pipeline/presentation/widgets/reload_on_return.dart';

const _pipeline = '/pipeline';
const _form = '/form';
const _quote = '/quote';

/// Pumps a router like the app's: the pipeline sits inside a shell and the
/// form / quote screens are full-screen routes above it.
Future<({GoRouter router, List<int> reloads})> _pump(
  WidgetTester tester,
) async {
  final reloads = <int>[];
  final router = GoRouter(
    initialLocation: _pipeline,
    routes: [
      ShellRoute(
        builder: (_, _, child) => child,
        routes: [
          GoRoute(
            path: _pipeline,
            builder: (_, _) => ReloadOnReturn(
              path: _pipeline,
              onReturn: () => reloads.add(reloads.length),
              child: const Text('pipeline'),
            ),
          ),
        ],
      ),
      GoRoute(path: _form, builder: (_, _) => const Text('form')),
      GoRoute(path: _quote, builder: (_, _) => const Text('quote')),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return (router: router, reloads: reloads);
}

void main() {
  testWidgets('does not reload on the first visit', (tester) async {
    final (:router, :reloads) = await _pump(tester);
    expect(find.text('pipeline'), findsOneWidget);
    expect(reloads, isEmpty);
    router.refresh();
    await tester.pumpAndSettle();
    expect(reloads, isEmpty);
  });

  testWidgets('reloads once when a pushed screen is popped', (tester) async {
    final (:router, :reloads) = await _pump(tester);
    router.push(_form);
    await tester.pumpAndSettle();
    expect(reloads, isEmpty);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('pipeline'), findsOneWidget);
    expect(reloads.length, 1);
  });

  testWidgets(
    'reloads when the form is replaced by the quote and then closed',
    (tester) async {
      final (:router, :reloads) = await _pump(tester);
      router.push(_form);
      await tester.pumpAndSettle();
      router.pushReplacement(_quote);
      await tester.pumpAndSettle();
      expect(find.text('quote'), findsOneWidget);
      expect(reloads, isEmpty);

      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('pipeline'), findsOneWidget);
      expect(reloads.length, 1);
    },
  );

  testWidgets('reloads again on every later return', (tester) async {
    final (:router, :reloads) = await _pump(tester);
    for (var i = 1; i <= 2; i++) {
      router.push(_quote);
      await tester.pumpAndSettle();
      router.pop();
      await tester.pumpAndSettle();
      expect(reloads.length, i);
    }
  });
}
