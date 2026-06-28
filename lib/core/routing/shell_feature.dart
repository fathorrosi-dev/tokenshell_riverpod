import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tokenshell_riverpod/core/routing/routes.dart';

/// Descriptor for a single navigation destination in the app shell.
///
/// Destinations are defined as pure data — no widget logic here.
/// The adaptive shell (`AppShell`) maps these to the appropriate
/// navigation widget (BottomNavigationBar / NavigationRail / NavigationDrawer).
///
/// Previously declared in `shared/shell/nav_destinations.dart`. Moved here
/// to live alongside [ShellFeature], which is what actually keeps a
/// destination in sync with its routes — see [ShellFeature]'s doc comment.
/// `nav_destinations.dart` and `feature_registry.dart` both re-export this
/// type, so nothing already importing either of them needs to change.
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

/// Pairs a feature's shell-level [RouteBase]s with the [NavDestination]
/// that represents it in the app shell's navigation.
///
/// ## Why this exists
///
/// Before this type, adding a shell-level feature needed two separate,
/// manually-synced edits: a `*ShellRoutes` entry spread into
/// `app_router.dart`'s [ShellRoute], AND a separate [NavDestination] entry
/// in what was `shared/shell/nav_destinations.dart`. Forgetting either
/// half failed silently — a route with no nav entry is simply unreachable
/// from the shell UI, and a nav entry with no matching route 404s the
/// moment it's tapped — with no compiler error pointing at the mismatch.
/// `core/di/providers.dart`'s barrel already proved this exact shape of
/// silent-drift problem happens for real in this codebase; this closes
/// the same gap in routing before it does too.
///
/// ## Adding a new shell-level feature
///
/// 1. In your feature's own `*_routes.dart`, import this file and define
///    a `ShellFeature get <name>ShellFeature` getter bundling your
///    existing `*ShellRoutes` with a [NavDestination] (see
///    `home_routes.dart` for the canonical example).
/// 2. Import it in `core/routing/feature_registry.dart` and add it to
///    `shellFeatures` there.
///
/// That's the only edit needed — same guarantee `app_router.dart` already
/// documented for routes alone, now extended to cover the nav entry too.
///
/// ## Why this type lives in its own file
///
/// This file deliberately has no dependency on anything under
/// `features/` — only [NavDestination] and `go_router`/`routes.dart`
/// types. `feature_registry.dart` is what imports every feature's
/// `*_routes.dart` to build [shellFeatures]; if the [ShellFeature] type
/// itself lived there too, every `*_routes.dart` constructing one would
/// have to import `feature_registry.dart` right back — a Core ↔ Feature
/// import cycle. Keeping the type definitions here, with feature files
/// depending only on this file (the same one-directional shape as their
/// existing `routes.dart` dependency), avoids that entirely.
final class ShellFeature {
  const ShellFeature({required this.destination, required this.routes});

  /// How this feature appears in the shell's navigation UI.
  final NavDestination destination;

  /// This feature's shell-level routes (rendered with nav chrome visible).
  final List<RouteBase> routes;
}
