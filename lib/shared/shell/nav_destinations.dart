import 'package:tokenshell_riverpod/core/routing/feature_registry.dart';

export 'package:tokenshell_riverpod/core/routing/feature_registry.dart'
    show NavDestination;

/// All top-level shell destinations, derived from [shellFeatures] — the
/// single source of truth shared with `core/routing/app_router.dart`'s
/// `ShellRoute.routes`.
///
/// Previously a hand-maintained list edited in lockstep with route
/// registration in `app_router.dart` — two separate touch points that
/// had to stay manually synced. See [ShellFeature]'s doc comment in
/// `core/routing/shell_feature.dart` for why that was a silent-drift
/// risk, and where to add a new shell-level feature now.
///
/// [NavDestination] itself now lives in `core/routing/shell_feature.dart`
/// — re-exported here (via `feature_registry.dart`) so nothing importing
/// this file needs to change.
///
/// Cached as a top-level `final` (not a `get`) for the same reason
/// [shellFeatures] is — see that field's doc comment in
/// `feature_registry.dart`. `shellFeatures` is already cached, so this
/// `.map().toList()` now only runs once too, instead of once per
/// `AppShell` build.
final List<NavDestination> appNavDestinations = List.unmodifiable(
  shellFeatures.map((f) => f.destination),
);
