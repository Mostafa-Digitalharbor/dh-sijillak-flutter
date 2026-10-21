import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/di/injection.dart';
import 'core/constants/app_config.dart';
import 'core/debug/debug_route_server.dart';
import 'core/error/crash_reporter.dart';
import 'core/error/global_error_handlers.dart';
import 'core/routing/app_router.dart';
import 'features/auth/domain/repositories/session_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Swap for a Sentry / Crashlytics reporter here (see CrashReporter).
  const reporter = ConsoleCrashReporter();
  installGlobalErrorHandlers(reporter);
  AppConfig.validateBackend(
    useMockBackend: AppConfig.useMockBackend,
    apiBaseUrl: AppConfig.apiBaseUrl,
  );
  await configureDependencies(crashReporter: reporter);
  final sessionStore = getIt<SessionStore>();
  reporter.setUser(sessionStore.current?.user.id);
  appRouter = createAppRouter(sessionStore: sessionStore, requireAuth: true);
  startDebugRouteServer();
  runApp(const SijilakApp());
}
