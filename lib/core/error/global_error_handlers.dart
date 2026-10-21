import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import 'crash_reporter.dart';

/// Routes every uncaught framework and platform error to [reporter].
///
/// `FlutterError.onError` covers errors thrown while building, laying out or
/// painting; `PlatformDispatcher.onError` covers async errors that escape
/// every `Future` (so no `runZonedGuarded` is needed). In release builds the
/// red error screen is replaced by [FriendlyErrorWidget].
void installGlobalErrorHandlers(CrashReporter reporter) {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    reporter.record(details.exception, details.stack, fatal: true);
    if (kDebugMode) previous?.call(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.record(error, stack, fatal: true);
    return true;
  };
  if (!kDebugMode) {
    ErrorWidget.builder = (details) => const FriendlyErrorWidget();
  }
}

/// Shown instead of a widget that failed to build, in release builds. Needs
/// no Theme or Directionality from its ancestors; the message appears only
/// when localisations are available.
class FriendlyErrorWidget extends StatelessWidget {
  const FriendlyErrorWidget({super.key});

  static const _iconSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: _iconSize,
            color: AppColors.textSubtle,
            textDirection: TextDirection.ltr,
          ),
          if (l10n != null)
            Text(
              l10n.errorUnknown,
              textAlign: TextAlign.center,
              textDirection:
                  Directionality.maybeOf(context) ?? TextDirection.ltr,
              style: const TextStyle(color: AppColors.textSubtle),
            ),
        ],
      ),
    );
  }
}
