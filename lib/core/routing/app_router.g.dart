// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

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

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
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
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'a7b96bf34f8a6bf6fcd34127244a931e543c39e5';
