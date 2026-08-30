import 'package:tokenshell_riverpod/core/routing/shell_feature.dart';
import 'package:tokenshell_riverpod/features/home/home_routes.dart';
import 'package:tokenshell_riverpod/features/posts/posts_routes.dart';
import 'package:tokenshell_riverpod/features/settings/settings_routes.dart';

export 'package:tokenshell_riverpod/core/routing/shell_feature.dart'
    show NavDestination, ShellFeature;

/// Single source of truth for every shell-level feature.
///
/// `core/routing/app_router.dart` derives `ShellRoute.routes` from this;
/// `shared/shell/nav_destinations.dart` derives `appNavDestinations` from
/// this. Order here is the visual order in BottomNavigationBar /
/// NavigationRail.
///
/// This is the only file in `core/routing/` that imports individual
/// feature `*_routes.dart` files — consistent with `app_router.dart`'s
/// pre-existing "Core imports feature route lists" pattern, just
/// consolidated one level higher so route registration and nav-entry
/// registration can no longer drift apart. See [ShellFeature]'s doc
/// comment for the full rationale, including why [ShellFeature] and
/// [NavDestination] themselves live in `shell_feature.dart` rather than
/// here: defining them here too would make every feature's `*_routes.dart`
/// import this file right back to construct one, which is exactly the
/// Core ↔ Feature import cycle this file's own feature imports must avoid
/// being part of.
///
/// To add a new shell-level feature: define its `*ShellFeature` getter in
/// its own `*_routes.dart` (importing `shell_feature.dart`, not this
/// file), import it here, and add it to this list. That's the only edit
/// needed.
///
/// ## Why this is a cached `final`, not a `get`
///
/// This used to be `List<ShellFeature> get shellFeatures => [...]` — a
/// getter that re-evaluated `homeShellFeature`, `settingsShellFeature`,
/// and `postsShellFeature` on every read. Each of *those* is itself a
/// getter that builds a new [ShellFeature] and calls its feature's
/// `*ShellRoutes` getter, which allocates a fresh `List<RouteBase>`
/// containing brand-new `GoRoute`s (with new `pageBuilder` closures)
/// every time. `shared/shell/app_shell.dart` reads the destinations
/// derived from this list at least twice per build (once for the
/// selected-tab index, once to lay out the nav bar/rail), and `AppShell`
/// rebuilds on every navigation event — so every tab switch was
/// reconstructing this app's entire routing object graph twice over,
/// purely to read three icon/label pairs.
///
/// Dart top-level `final`s initialize lazily, once, on first access — so
/// making this a `final` instead of a `get` means `homeShellFeature` /
/// `settingsShellFeature` / `postsShellFeature` (and therefore every
/// feature's `*ShellRoutes`) now run exactly once for the lifetime of the
/// isolate, no matter how many times `shellFeatures` is read afterwards.
/// `app_router.dart`'s one-time `GoRouter` construction and
/// `nav_destinations.dart`'s `appNavDestinations` both now share that
/// single cached list instead of each triggering their own rebuild.
final List<ShellFeature> shellFeatures = List.unmodifiable([
  homeShellFeature,
  settingsShellFeature,
  postsShellFeature,
]);
