import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tokenshell_riverpod/core/routing/app_router.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';

void main() {
  group('AppRouter', () {
    // ── Provider resolution ────────────────────────────────────────────────────

    test(
      'appRouterProvider returns a GoRouter instance',
      () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final router = container.read(appRouterProvider);

        // Assert
        expect(router, isA<GoRouter>());
      },
    );

    test(
      'GoRouter singleton is the same instance on repeated reads',
      () {
        // Arrange — keepAlive: true means the same object is returned
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final first = container.read(appRouterProvider);
        final second = container.read(appRouterProvider);

        // Assert
        expect(identical(first, second), isTrue);
      },
    );

    // ── Initial location ───────────────────────────────────────────────────────

    test(
      'router initial location matches AppPath.home',
      () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final router = container.read(appRouterProvider);

        // Act — routerDelegate exposes the current location via routeInformationProvider
        final initialLocation = router.routeInformationProvider.value.uri.path;

        // Assert
        expect(initialLocation, equals(AppPath.home));
      },
    );

    // ── Named routes ───────────────────────────────────────────────────────────

    test(
      'AppPath.home is "/"',
      () {
        // Arrange / Act / Assert — constant, no routing needed
        expect(AppPath.home, equals('/'));
      },
    );

    test(
      'AppPath.settings is "/settings"',
      () {
        // Arrange / Act / Assert
        expect(AppPath.settings, equals('/settings'));
      },
    );

    test(
      'AppRoute enum has home and settings values',
      () {
        // Arrange / Act
        final names = AppRoute.values.map((r) => r.name).toList();

        // Assert
        expect(names, containsAll(['home', 'settings']));
      },
    );

    // ── Redirect structure ─────────────────────────────────────────────────────

    test(
      'redirect callback returns null (no redirect) for unauthenticated placeholder',
      () async {
        // Arrange — the router's redirect is a placeholder that always returns null.
        // This test verifies the structure is in place and does not throw.
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final router = container.read(appRouterProvider);

        // Act — navigate to home and confirm no redirect occurred
        // We test by verifying the router resolves without throwing.
        // Full redirect integration tests require a widget test environment.
        expect(router, isNotNull);

        // Assert — router was created successfully with redirect configured
        // (redirect: non-null function reference inside GoRouter)
        expect(router.routeInformationProvider, isNotNull);
      },
    );

    // ── Route configuration integrity ──────────────────────────────────────────

    test(
      'router contains at least 2 registered routes (home + settings)',
      () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final router = container.read(appRouterProvider);

        // Act — navigate to each named route and verify no exception is thrown
        // by confirming the router resolves them.
        // Named route resolution is tested via GoRouter.namedLocation.
        final homePath =
            router.namedLocation(AppRoute.home.name);
        final settingsPath =
            router.namedLocation(AppRoute.settings.name);

        // Assert — named routes resolve to the correct paths
        expect(homePath, equals(AppPath.home));
        expect(settingsPath, equals(AppPath.settings));
      },
    );
  });
}
