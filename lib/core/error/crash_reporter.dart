import 'package:flutter/foundation.dart';

/// Sink for errors nobody handled (and for unexpected failures worth
/// knowing about).
///
/// To ship reports to Sentry or Firebase Crashlytics, implement this
/// interface (`record` -> `Sentry.captureException` /
/// `FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal)`,
/// `setUser` -> `Sentry.configureScope` / `setUserIdentifier`), initialise the
/// SDK in `main()` before `configureDependencies`, and pass the instance as
/// `configureDependencies(crashReporter: ...)`. Nothing else changes: the
/// global handlers in `installGlobalErrorHandlers` already call it.
abstract interface class CrashReporter {
  /// Reports [error]; [fatal] is true for errors that escaped every handler.
  void record(Object error, StackTrace? stack, {bool fatal = false});

  /// Associates later reports with the signed-in user ([id] null on sign-out).
  /// Pass an opaque id, never a name, email or phone number.
  void setUser(String? id);
}

/// Prints reports in debug builds and stays silent in release.
class ConsoleCrashReporter implements CrashReporter {
  const ConsoleCrashReporter();

  @override
  void record(Object error, StackTrace? stack, {bool fatal = false}) {
    if (!kDebugMode) return;
    debugPrint('[crash${fatal ? ' fatal' : ''}] $error');
    if (stack != null) debugPrint('$stack');
  }

  @override
  void setUser(String? id) {
    if (kDebugMode) debugPrint('[crash] user=${id ?? 'none'}');
  }
}
