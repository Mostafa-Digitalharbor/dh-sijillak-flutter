import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/l10n/l10n.dart';
import '../core/layout/responsive.dart';
import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/account/domain/entities/app_language.dart';
import '../features/account/presentation/cubit/locale_cubit.dart';
import 'di/injection.dart';

class SijilakApp extends StatelessWidget {
  const SijilakApp({super.key, this.locale});

  /// Forces the UI language (tests, previews). When null the app follows the
  /// user's choice held by [LocaleCubit]: the saved language, else the
  /// build-time default.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, AppLanguage>(
        builder: (context, language) => MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: appRouter,
          builder: (context, child) => ResponsiveFrame(child: child!),
          locale: locale ?? Locale(language.code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
  }
}
