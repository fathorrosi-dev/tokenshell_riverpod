import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/core/routing/shell_feature.dart';
import 'package:tokenshell_riverpod/features/home/presentation/home_page.dart';

/// Shell-level routes for the Home feature.
///
/// Imported by [app_router.dart] and spread into the [ShellRoute.routes]
/// list. Core routing imports this route list — never [HomePage] directly.
/// This keeps the Core/Feature dependency direction clean: Core knows
/// *that* a home feature exists (via this list), but not *how* it renders.
///
/// To add a nested home sub-route, add a [GoRoute.routes] entry here.
/// [app_router.dart] never needs to change for home feature route additions.
List<RouteBase> get homeShellRoutes => [
  GoRoute(
    path: AppPath.home,
    name: AppRoute.home.name,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: HomePage(),
    ),
  ),
];

/// This feature's single entry in `core/routing/feature_registry.dart`'s
/// `shellFeatures` list — bundles [homeShellRoutes] with this feature's
/// nav appearance so both stay in sync from one declaration. See
/// [ShellFeature]'s doc comment for why this replaced two separate,
/// manually-synced touch points.
ShellFeature get homeShellFeature => ShellFeature(
  destination: const NavDestination(
    route: AppRoute.home,
    path: AppPath.home,
    label: AppStrings.navHome,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  routes: homeShellRoutes,
);
