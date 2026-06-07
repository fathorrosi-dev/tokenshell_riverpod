// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [Connectivity] plugin singleton.

@ProviderFor(connectivity)
final connectivityProvider = ConnectivityProvider._();

/// Provides the [Connectivity] plugin singleton.

final class ConnectivityProvider
    extends $FunctionalProvider<Connectivity, Connectivity, Connectivity>
    with $Provider<Connectivity> {
  /// Provides the [Connectivity] plugin singleton.
  ConnectivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityHash();

  @$internal
  @override
  $ProviderElement<Connectivity> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Connectivity create(Ref ref) {
    return connectivity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Connectivity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Connectivity>(value),
    );
  }
}

String _$connectivityHash() => r'e66720f09edf1a8b09e450e1eaedd51da9443f0e';

/// Stream provider that emits the current [ConnectivityResult] list
/// whenever the device's network status changes.
///
/// Consumers can `watch` this provider to reactively rebuild on connectivity
/// changes, or `read` it for one-shot checks.

@ProviderFor(connectivityStream)
final connectivityStreamProvider = ConnectivityStreamProvider._();

/// Stream provider that emits the current [ConnectivityResult] list
/// whenever the device's network status changes.
///
/// Consumers can `watch` this provider to reactively rebuild on connectivity
/// changes, or `read` it for one-shot checks.

final class ConnectivityStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConnectivityResult>>,
          List<ConnectivityResult>,
          Stream<List<ConnectivityResult>>
        >
    with
        $FutureModifier<List<ConnectivityResult>>,
        $StreamProvider<List<ConnectivityResult>> {
  /// Stream provider that emits the current [ConnectivityResult] list
  /// whenever the device's network status changes.
  ///
  /// Consumers can `watch` this provider to reactively rebuild on connectivity
  /// changes, or `read` it for one-shot checks.
  ConnectivityStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ConnectivityResult>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ConnectivityResult>> create(Ref ref) {
    return connectivityStream(ref);
  }
}

String _$connectivityStreamHash() =>
    r'67159f6e1fedd7ed3da5924800bdf232db68da4c';

/// Checks the current connectivity status once and returns `true` if the
/// device has an active network connection.
///
/// Prefer [connectivityStreamProvider] for reactive UI; use this utility
/// inside repository methods before making network requests.

@ProviderFor(isConnected)
final isConnectedProvider = IsConnectedProvider._();

/// Checks the current connectivity status once and returns `true` if the
/// device has an active network connection.
///
/// Prefer [connectivityStreamProvider] for reactive UI; use this utility
/// inside repository methods before making network requests.

final class IsConnectedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Checks the current connectivity status once and returns `true` if the
  /// device has an active network connection.
  ///
  /// Prefer [connectivityStreamProvider] for reactive UI; use this utility
  /// inside repository methods before making network requests.
  IsConnectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isConnectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isConnectedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isConnected(ref);
  }
}

String _$isConnectedHash() => r'ed9e1d5b48410a3ccc506f4c8d6c6155ba3199e0';
