// dart run build_runner build --delete-conflicting-outputs
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/features/home/presentation/home_page.dart';
import 'package:tokenshell_riverpod/features/settings/presentation/settings_page.dart';
import 'package:tokenshell_riverpod/shared/shell/app_shell.dart';

part 'app_router.g.dart';

/// Provides the application's [GoRouter] instance.
///
/// The router is a singleton: [keepAlive: true] prevents recreation on
/// provider refresh and avoids inadvertent navigation state resets.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppPath.home,
    debugLogDiagnostics: true,

    // ── Auth redirect placeholder ────────────────────────────────────────────
    // Replace the null return below with your auth redirect logic.
    // Example:
    //   final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
    //   final isOnAuthRoute = state.matchedLocation.startsWith('/login');
    //   if (!isAuthenticated && !isOnAuthRoute) return '/login';
    //   if (isAuthenticated && isOnAuthRoute) return AppPath.home;
    //   return null; // no redirect
    redirect: (context, state) {
      // Auth guard — implement here.
      return null;
    },

    routes: [
      // ── Shell route — wraps all main app destinations ────────────────────
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppPath.home,
            name: AppRoute.home.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: AppPath.settings,
            name: AppRoute.settings.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
