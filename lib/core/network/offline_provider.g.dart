// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Derives a single offline boolean from [connectivityStreamProvider],
/// notifying listeners only when the binary online/offline state actually
/// changes.
///
/// ## Why a derived provider instead of watching the stream directly
///
/// [connectivityStreamProvider] emits a `List<ConnectivityResult>` on
/// every adapter change — including transitions that do NOT change whether
/// the device is offline, such as a WiFi → cellular handover while both
/// remain available. Widgets that watch the raw stream rebuild on all of
/// these events, even when nothing they render has changed.
///
/// [AppShell] is the primary consumer and sits at the root of the
/// navigation shell, wrapping [NavigationBar] / [NavigationRail] and the
/// entire active page. Rebuilding it on a WiFi → cellular switch that
/// leaves the device online is pure overhead — the offline banner's
/// visibility doesn't change, the shell layout doesn't change, nothing
/// changes. This derived provider collapses the stream into a boolean so
/// [AppShell] only rebuilds when the "is offline" flag actually flips.
///
/// Added R-08 (27 Jun 2026) — production readiness audit.
///
/// [keepAlive: true] — matches [connectivityStreamProvider]'s own
/// lifecycle. Both live for the app's entire lifetime; disposing this
/// provider while the stream is still active would just recreate an
/// identical computed value on the next watch, which is wasteful.

@ProviderFor(isOffline)
final isOfflineProvider = IsOfflineProvider._();

/// Derives a single offline boolean from [connectivityStreamProvider],
/// notifying listeners only when the binary online/offline state actually
/// changes.
///
/// ## Why a derived provider instead of watching the stream directly
///
/// [connectivityStreamProvider] emits a `List<ConnectivityResult>` on
/// every adapter change — including transitions that do NOT change whether
/// the device is offline, such as a WiFi → cellular handover while both
/// remain available. Widgets that watch the raw stream rebuild on all of
/// these events, even when nothing they render has changed.
///
/// [AppShell] is the primary consumer and sits at the root of the
/// navigation shell, wrapping [NavigationBar] / [NavigationRail] and the
/// entire active page. Rebuilding it on a WiFi → cellular switch that
/// leaves the device online is pure overhead — the offline banner's
/// visibility doesn't change, the shell layout doesn't change, nothing
/// changes. This derived provider collapses the stream into a boolean so
/// [AppShell] only rebuilds when the "is offline" flag actually flips.
///
/// Added R-08 (27 Jun 2026) — production readiness audit.
///
/// [keepAlive: true] — matches [connectivityStreamProvider]'s own
/// lifecycle. Both live for the app's entire lifetime; disposing this
/// provider while the stream is still active would just recreate an
/// identical computed value on the next watch, which is wasteful.

final class IsOfflineProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Derives a single offline boolean from [connectivityStreamProvider],
  /// notifying listeners only when the binary online/offline state actually
  /// changes.
  ///
  /// ## Why a derived provider instead of watching the stream directly
  ///
  /// [connectivityStreamProvider] emits a `List<ConnectivityResult>` on
  /// every adapter change — including transitions that do NOT change whether
  /// the device is offline, such as a WiFi → cellular handover while both
  /// remain available. Widgets that watch the raw stream rebuild on all of
  /// these events, even when nothing they render has changed.
  ///
  /// [AppShell] is the primary consumer and sits at the root of the
  /// navigation shell, wrapping [NavigationBar] / [NavigationRail] and the
  /// entire active page. Rebuilding it on a WiFi → cellular switch that
  /// leaves the device online is pure overhead — the offline banner's
  /// visibility doesn't change, the shell layout doesn't change, nothing
  /// changes. This derived provider collapses the stream into a boolean so
  /// [AppShell] only rebuilds when the "is offline" flag actually flips.
  ///
  /// Added R-08 (27 Jun 2026) — production readiness audit.
  ///
  /// [keepAlive: true] — matches [connectivityStreamProvider]'s own
  /// lifecycle. Both live for the app's entire lifetime; disposing this
  /// provider while the stream is still active would just recreate an
  /// identical computed value on the next watch, which is wasteful.
  IsOfflineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOfflineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOfflineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOffline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOfflineHash() => r'8889b79088fd69f3a9c3aa5df87e012a573524c3';
