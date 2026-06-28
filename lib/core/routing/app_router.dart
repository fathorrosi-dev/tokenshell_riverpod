// dart run build_runner build --delete-conflicting-outputs
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/routing/feature_registry.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';
// `feature_registry.dart` aggregates every feature's shell routes + nav
// destination via `shellFeatures` (see that file for the single-edit-point
// this gives new features). `posts_routes.dart` is still imported directly
// here only for `postsStandaloneRoutes` — the detail page route, which is
// deliberately NOT part of `shellFeatures` since it renders outside the
// shell's nav chrome.
import 'package:tokenshell_riverpod/features/posts/posts_routes.dart';
import 'package:tokenshell_riverpod/shared/shell/app_shell.dart';
import 'package:tokenshell_riverpod/shared/widgets/app_state_view.dart';

part 'app_router.g.dart';

/// Provides the application's [GoRouter] instance.
///
/// The router is a singleton: [keepAlive: true] prevents recreation on
/// provider refresh and avoids inadvertent navigation state resets.
///
/// ## Adding a new feature
///
/// **Shell-level feature** (appears in bottom nav / rail, e.g. Home,
/// Settings, Posts): define a `ShellFeature` getter in your feature's own
/// `*_routes.dart` and add it to `shellFeatures` in
/// `core/routing/feature_registry.dart`. This file never changes.
///
/// **Standalone feature** (full-screen, no nav chrome, e.g. Posts'
/// detail page): expose a `List<RouteBase> get <name>StandaloneRoutes`
/// getter from your `*_routes.dart` and spread it at the same level as
/// the [ShellRoute] below.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppPath.home,
    // Verbose route-matching diagnostics are only useful during
    // development — printing them in a release build leaks internal
    // navigation structure into the production console for no benefit.
    debugLogDiagnostics: kDebugMode,

    // ── Auth redirect placeholder ────────────────────────────────────────────
    // Replace the null return below with your auth redirect logic.
    // Example:
    //   final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
    //   final isOnAuthRoute = state.matchedLocation.startsWith('/login');
    //   if (!isAuthenticated && !isOnAuthRoute) return '/login';
    //   if (isAuthenticated && isOnAuthRoute) return AppPath.home;
    //   return null; // no redirect
    //
    // Gotcha: a `ref.read(...)` snapshot here only re-evaluates on the
    // next navigation. If auth state needs to redirect immediately on
    // change (e.g. logout while already in the app), wire this router's
    // `refreshListenable` to a Listenable that notifies on auth state
    // changes — otherwise this redirect silently goes stale.
    //
    // FIXED: was `(context, state)` — [context] was never used and implied
    // it was needed for auth redirect logic. Using `_` makes it explicit
    // that only [state] (GoRouterState) matters here, preventing developers
    // from accidentally depending on a BuildContext that may be stale.
    redirect: (_, state) {
      // Auth guard — implement here.
      return null;
    },

    // Default go_router error page is unbranded and not user-friendly —
    // this keeps an unmatched/broken deep link inside the app's own look.
    errorBuilder: (context, state) => _NotFoundPage(uri: state.uri),

    routes: [
      // ── Shell route — wraps all main app destinations ────────────────────
      // Routes derived from `shellFeatures`
      // (core/routing/feature_registry.dart) — the single source of truth
      // shared with `nav_destinations.dart`'s `appNavDestinations`. Order
      // there is tab/rail order in [AppShell].
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: shellFeatures.expand((feature) => feature.routes).toList(),
      ),

      // ── Standalone routes — full-screen, no nav chrome ───────────────────
      // Detail and modal routes live outside the shell. Each feature that
      // has standalone routes exposes a separate `*StandaloneRoutes` getter.
      ...postsStandaloneRoutes,
    ],
  );
}

// ── Error page ──────────────────────────────────────────────────────────────

/// Shown for any unmatched route — broken deep link, typo'd URL, or a
/// path that simply doesn't exist. Built on the same [AppStateView] used
/// by `posts_page.dart`'s empty/error states, rather than a hand-rolled
/// duplicate of that layout.
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: AppStateView(
        icon: Icons.signpost_outlined,
        title: AppStrings.notFoundTitle,
        message: AppStrings.notFoundMessage(uri),
        actionLabel: AppStrings.notFoundActionLabel,
        // Uses the AppContextX extension's `goNamedRoute` — safe to call
        // via plain `context.` syntax now that it no longer shares a name
        // with go_router's built-in `GoRouterHelper.goNamed`. Previously
        // this had to call `GoRouterHelper(context).goNamed(...)`
        // explicitly to resolve an ambiguous-extension compile error.
        onAction: () => context.goNamedRoute(AppRoute.home.name),
      ),
    );
  }
}
