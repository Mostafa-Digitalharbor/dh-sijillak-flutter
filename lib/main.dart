import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/di/injection.dart';
import 'core/debug/debug_route_server.dart';
import 'core/routing/app_router.dart';
import 'features/auth/domain/repositories/session_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  appRouter = createAppRouter(
    sessionStore: getIt<SessionStore>(),
    requireAuth: true,
  );
  startDebugRouteServer();
  runApp(const SijilakApp());
}
