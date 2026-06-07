import 'package:flutter/material.dart';

import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/shared/shell/app_shell.dart';

/// Descriptor for a single navigation destination in the app shell.
///
/// Destinations are defined as pure data — no widget logic here.
/// The adaptive shell ([AppShell]) maps these to the appropriate
/// navigation widget (BottomNavigationBar / NavigationRail / NavigationDrawer).
final class NavDestination {
  const NavDestination({
    required this.route,
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  /// The [AppRoute] enum value — used for programmatic navigation.
  final AppRoute route;

  /// Absolute path — used to determine the selected index via location matching.
  final String path;

  /// Display label shown in navigation widgets.
  final String label;

  /// Icon for the unselected state.
  final IconData icon;

  /// Icon for the selected / active state.
  final IconData selectedIcon;
}

/// All top-level shell destinations.
///
/// Order determines the visual order in BottomNavigationBar and NavigationRail.
/// Add new entries here when introducing a new shell-level feature route;
/// no other shell file needs modification.
const List<NavDestination> appNavDestinations = [
  NavDestination(
    route: AppRoute.home,
    path: AppPath.home,
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  NavDestination(
    route: AppRoute.settings,
    path: AppPath.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
];
