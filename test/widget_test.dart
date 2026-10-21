import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sijilak/app/app.dart';

import 'helpers/test_dependencies.dart';

void main() {
  testWidgets('app starts on the welcome screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await configureTestDependencies();
    await tester.pumpWidget(const SijilakApp());
    await tester.pump();
    expect(find.text('أنشئ حساب شركتك مجاناً'), findsOneWidget);
  });
}
