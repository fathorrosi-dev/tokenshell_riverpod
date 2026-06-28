// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_flavor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current [AppFlavor] throughout the app.
///
/// [keepAlive: true] — the flavor is baked in at compile time and is
/// constant for the entire app lifetime. There is no reason to ever
/// dispose and recreate this provider.
///
/// Consume via `ref.watch(appFlavorProvider)` in notifiers or widgets.
/// Use `ref.read(appFlavorProvider)` for one-off checks (e.g. in
/// logging setup or DI configuration at startup).

@ProviderFor(appFlavor)
final appFlavorProvider = AppFlavorProvider._();

/// Provides the current [AppFlavor] throughout the app.
///
/// [keepAlive: true] — the flavor is baked in at compile time and is
/// constant for the entire app lifetime. There is no reason to ever
/// dispose and recreate this provider.
///
/// Consume via `ref.watch(appFlavorProvider)` in notifiers or widgets.
/// Use `ref.read(appFlavorProvider)` for one-off checks (e.g. in
/// logging setup or DI configuration at startup).

final class AppFlavorProvider
    extends $FunctionalProvider<AppFlavor, AppFlavor, AppFlavor>
    with $Provider<AppFlavor> {
  /// Provides the current [AppFlavor] throughout the app.
  ///
  /// [keepAlive: true] — the flavor is baked in at compile time and is
  /// constant for the entire app lifetime. There is no reason to ever
  /// dispose and recreate this provider.
  ///
  /// Consume via `ref.watch(appFlavorProvider)` in notifiers or widgets.
  /// Use `ref.read(appFlavorProvider)` for one-off checks (e.g. in
  /// logging setup or DI configuration at startup).
  AppFlavorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appFlavorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appFlavorHash();

  @$internal
  @override
  $ProviderElement<AppFlavor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppFlavor create(Ref ref) {
    return appFlavor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppFlavor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppFlavor>(value),
    );
  }
}

String _$appFlavorHash() => r'ebea875123efe1173e45b382308efd8089ae7a4a';
