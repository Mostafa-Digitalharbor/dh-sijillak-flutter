import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/app_icons.dart';
import '../core/l10n/l10n.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_colors.dart';
import 'widgets/floating_nav_bar.dart';
import 'widgets/nav_item.dart';

/// Hosts the four main tabs with the floating bottom navigation bar.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static List<NavTab> _tabs(AppLocalizations l10n) => [
    NavTab(AppRoutes.home, l10n.navHome, AppIcons.home),
    NavTab(AppRoutes.pipeline, l10n.navPipeline, AppIcons.funnel),
    NavTab(AppRoutes.customers, l10n.navCustomers, AppIcons.people),
    NavTab(AppRoutes.invoices, l10n.invoices, AppIcons.doc),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          FloatingNavBar(
            tabs: _tabs(context.l10n),
            location: GoRouterState.of(context).uri.path,
          ),
        ],
      ),
    );
  }
}
