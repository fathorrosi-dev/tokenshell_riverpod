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

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Provides the application's [GoRouter] instance.
///
/// The router is a singleton: [keepAlive: true] prevents recreation on
/// provider refresh and avoids inadvertent navigation state resets.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Provides the application's [GoRouter] instance.
  ///
  /// The router is a singleton: [keepAlive: true] prevents recreation on
  /// provider refresh and avoids inadvertent navigation state resets.
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

String _$appRouterHash() => r'e6dd48fd9fc600828c0ed9999d4af276e312a345';
