import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/core/routing/shell_feature.dart';
import 'package:tokenshell_riverpod/features/settings/presentation/settings_page.dart';

/// Shell-level routes for the Settings feature.
///
/// Imported by [app_router.dart] and spread into the [ShellRoute.routes]
/// list. Core routing imports this route list — never [SettingsPage] directly.
///
/// To add a nested settings sub-route (e.g. account, notifications),
/// add a [GoRoute.routes] entry here. [app_router.dart] never changes.
List<RouteBase> get settingsShellRoutes => [
  GoRoute(
    path: AppPath.settings,
    name: AppRoute.settings.name,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: SettingsPage(),
    ),
  ),
];

/// This feature's single entry in `core/routing/feature_registry.dart`'s
/// `shellFeatures` list — bundles [settingsShellRoutes] with this
/// feature's nav appearance so both stay in sync from one declaration.
ShellFeature get settingsShellFeature => ShellFeature(
  destination: const NavDestination(
    route: AppRoute.settings,
    path: AppPath.settings,
    label: AppStrings.navSettings,
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
  routes: settingsShellRoutes,
);
