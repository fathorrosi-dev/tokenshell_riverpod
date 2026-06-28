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
/// [keepAlive: true] — connectivity changes are app-lifetime events.
/// Without keepAlive, the stream subscription disposes when no widget
/// is actively watching it, creating a gap where connectivity changes
/// go undetected during screen transitions (e.g. navigating between
/// pages briefly clears all watchers).
///
/// Consumers can `watch` this provider to reactively rebuild on connectivity
/// changes, or `read` it for one-shot checks.

@ProviderFor(connectivityStream)
final connectivityStreamProvider = ConnectivityStreamProvider._();

/// Stream provider that emits the current [ConnectivityResult] list
/// whenever the device's network status changes.
///
/// [keepAlive: true] — connectivity changes are app-lifetime events.
/// Without keepAlive, the stream subscription disposes when no widget
/// is actively watching it, creating a gap where connectivity changes
/// go undetected during screen transitions (e.g. navigating between
/// pages briefly clears all watchers).
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
  /// [keepAlive: true] — connectivity changes are app-lifetime events.
  /// Without keepAlive, the stream subscription disposes when no widget
  /// is actively watching it, creating a gap where connectivity changes
  /// go undetected during screen transitions (e.g. navigating between
  /// pages briefly clears all watchers).
  ///
  /// Consumers can `watch` this provider to reactively rebuild on connectivity
  /// changes, or `read` it for one-shot checks.
  ConnectivityStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityStreamProvider',
        isAutoDispose: false,
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
    r'3c98a132998a315d1957c8c40713ebc404218666';

/// Bare, interceptor-free [Dio] instance dedicated to the reachability probe.
///
/// Extracted into a [keepAlive] provider (replacing the previous module-level
/// singleton) so tests can override it with a mock Dio — making connectivity
/// checks fully testable without real network calls.
///
/// Deliberately NOT the app's main [dioProvider] — that one carries Auth,
/// Retry, and Logger interceptors that have no business running against a
/// throwaway probe (Retry in particular would silently multiply a check
/// that's supposed to stay fast and cheap).
///
/// `connectTimeout` of 5 seconds — was 3. Pagination's `loadMore()` calls
/// this probe far more often per session than the pre-pagination one-shot
/// list load did, which surfaced 3 seconds as too tight a margin on real
/// mobile networks: ordinary latency variance (not an actual outage) was
/// occasionally enough to time out and report "unreachable." 5 seconds
/// gives a slow-but-working connection a real chance to succeed, while
/// still failing well short of what would feel like a frozen UI.

@ProviderFor(probeDio)
final probeDioProvider = ProbeDioProvider._();

/// Bare, interceptor-free [Dio] instance dedicated to the reachability probe.
///
/// Extracted into a [keepAlive] provider (replacing the previous module-level
/// singleton) so tests can override it with a mock Dio — making connectivity
/// checks fully testable without real network calls.
///
/// Deliberately NOT the app's main [dioProvider] — that one carries Auth,
/// Retry, and Logger interceptors that have no business running against a
/// throwaway probe (Retry in particular would silently multiply a check
/// that's supposed to stay fast and cheap).
///
/// `connectTimeout` of 5 seconds — was 3. Pagination's `loadMore()` calls
/// this probe far more often per session than the pre-pagination one-shot
/// list load did, which surfaced 3 seconds as too tight a margin on real
/// mobile networks: ordinary latency variance (not an actual outage) was
/// occasionally enough to time out and report "unreachable." 5 seconds
/// gives a slow-but-working connection a real chance to succeed, while
/// still failing well short of what would feel like a frozen UI.

final class ProbeDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Bare, interceptor-free [Dio] instance dedicated to the reachability probe.
  ///
  /// Extracted into a [keepAlive] provider (replacing the previous module-level
  /// singleton) so tests can override it with a mock Dio — making connectivity
  /// checks fully testable without real network calls.
  ///
  /// Deliberately NOT the app's main [dioProvider] — that one carries Auth,
  /// Retry, and Logger interceptors that have no business running against a
  /// throwaway probe (Retry in particular would silently multiply a check
  /// that's supposed to stay fast and cheap).
  ///
  /// `connectTimeout` of 5 seconds — was 3. Pagination's `loadMore()` calls
  /// this probe far more often per session than the pre-pagination one-shot
  /// list load did, which surfaced 3 seconds as too tight a margin on real
  /// mobile networks: ordinary latency variance (not an actual outage) was
  /// occasionally enough to time out and report "unreachable." 5 seconds
  /// gives a slow-but-working connection a real chance to succeed, while
  /// still failing well short of what would feel like a frozen UI.
  ProbeDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'probeDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$probeDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return probeDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$probeDioHash() => r'a9b80b95aa92d278d74d726c13ff1f41bc72dba5';

/// Holds the last reachability probe result inside the Riverpod graph.
///
/// ## Why a Riverpod notifier instead of a module-level variable?
///
/// The previous implementation stored the cache as a module-level
/// `_ReachabilityCache?` variable. That worked at runtime but had two
/// structural problems:
///
/// 1. **Invisible to the provider graph** — the cache couldn't be overridden
///    via `ProviderScope.overrides`, making it impossible to seed or clear
///    in isolation (e.g. to simulate "first-run, no cache" in an integration
///    test environment without touching global state).
///
/// 2. **Persists across ProviderScope lifetimes** — if a test re-created
///    a `ProviderContainer`, the old cache value would silently survive in
///    the module-level variable, leaking state between test runs.
///
/// Moving the cache here makes it a first-class Riverpod citizen: scoped to
/// the `ProviderScope`, overridable in tests, and inspectable by devtools.
///
/// [keepAlive: true] — the cache must outlive individual
/// [ConnectivityService.isConnected] calls. If this notifier were autoDispose,
/// it would reset the moment the check completes, defeating the entire purpose
/// of caching the probe result.

@ProviderFor(ReachabilityCache)
final reachabilityCacheProvider = ReachabilityCacheProvider._();

/// Holds the last reachability probe result inside the Riverpod graph.
///
/// ## Why a Riverpod notifier instead of a module-level variable?
///
/// The previous implementation stored the cache as a module-level
/// `_ReachabilityCache?` variable. That worked at runtime but had two
/// structural problems:
///
/// 1. **Invisible to the provider graph** — the cache couldn't be overridden
///    via `ProviderScope.overrides`, making it impossible to seed or clear
///    in isolation (e.g. to simulate "first-run, no cache" in an integration
///    test environment without touching global state).
///
/// 2. **Persists across ProviderScope lifetimes** — if a test re-created
///    a `ProviderContainer`, the old cache value would silently survive in
///    the module-level variable, leaking state between test runs.
///
/// Moving the cache here makes it a first-class Riverpod citizen: scoped to
/// the `ProviderScope`, overridable in tests, and inspectable by devtools.
///
/// [keepAlive: true] — the cache must outlive individual
/// [ConnectivityService.isConnected] calls. If this notifier were autoDispose,
/// it would reset the moment the check completes, defeating the entire purpose
/// of caching the probe result.
final class ReachabilityCacheProvider
    extends $NotifierProvider<ReachabilityCache, ProbeResult?> {
  /// Holds the last reachability probe result inside the Riverpod graph.
  ///
  /// ## Why a Riverpod notifier instead of a module-level variable?
  ///
  /// The previous implementation stored the cache as a module-level
  /// `_ReachabilityCache?` variable. That worked at runtime but had two
  /// structural problems:
  ///
  /// 1. **Invisible to the provider graph** — the cache couldn't be overridden
  ///    via `ProviderScope.overrides`, making it impossible to seed or clear
  ///    in isolation (e.g. to simulate "first-run, no cache" in an integration
  ///    test environment without touching global state).
  ///
  /// 2. **Persists across ProviderScope lifetimes** — if a test re-created
  ///    a `ProviderContainer`, the old cache value would silently survive in
  ///    the module-level variable, leaking state between test runs.
  ///
  /// Moving the cache here makes it a first-class Riverpod citizen: scoped to
  /// the `ProviderScope`, overridable in tests, and inspectable by devtools.
  ///
  /// [keepAlive: true] — the cache must outlive individual
  /// [ConnectivityService.isConnected] calls. If this notifier were autoDispose,
  /// it would reset the moment the check completes, defeating the entire purpose
  /// of caching the probe result.
  ReachabilityCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reachabilityCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reachabilityCacheHash();

  @$internal
  @override
  ReachabilityCache create() => ReachabilityCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProbeResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProbeResult?>(value),
    );
  }
}

String _$reachabilityCacheHash() => r'6ce19809a663835419d6b9a524d3ecf7f927591d';

/// Holds the last reachability probe result inside the Riverpod graph.
///
/// ## Why a Riverpod notifier instead of a module-level variable?
///
/// The previous implementation stored the cache as a module-level
/// `_ReachabilityCache?` variable. That worked at runtime but had two
/// structural problems:
///
/// 1. **Invisible to the provider graph** — the cache couldn't be overridden
///    via `ProviderScope.overrides`, making it impossible to seed or clear
///    in isolation (e.g. to simulate "first-run, no cache" in an integration
///    test environment without touching global state).
///
/// 2. **Persists across ProviderScope lifetimes** — if a test re-created
///    a `ProviderContainer`, the old cache value would silently survive in
///    the module-level variable, leaking state between test runs.
///
/// Moving the cache here makes it a first-class Riverpod citizen: scoped to
/// the `ProviderScope`, overridable in tests, and inspectable by devtools.
///
/// [keepAlive: true] — the cache must outlive individual
/// [ConnectivityService.isConnected] calls. If this notifier were autoDispose,
/// it would reset the moment the check completes, defeating the entire purpose
/// of caching the probe result.

abstract class _$ReachabilityCache extends $Notifier<ProbeResult?> {
  ProbeResult? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProbeResult?, ProbeResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProbeResult?, ProbeResult?>,
              ProbeResult?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Stateless keepAlive service that runs all connectivity checks for the app.
///
/// ## Why a keepAlive Notifier instead of a FutureProvider (`@riverpod`)
///
/// The previous implementation used `@riverpod Future<bool> isConnected(...)`
/// — an autoDispose FutureProvider accessed via `ref.read()`. That pattern
/// has a fundamental lifecycle mismatch:
///
/// `ref.read()` does NOT add a persistent listener. With no active listeners,
/// Riverpod schedules the autoDispose provider for disposal on the next event
/// loop iteration. Because `isConnected` contained two `await` gaps
/// (`checkConnectivity()` + the reachability probe), the provider was
/// frequently disposed *between* those awaits — before the async computation
/// finished. Once disposed, `ref.mounted` became `false`, causing the function
/// to return `false` early and throw a spurious [NetworkFailure] even on a
/// fully working connection.
///
/// A `keepAlive: true` Notifier's `ref` is valid for the entire app lifetime.
/// Methods on this notifier can safely call `ref.read()` at any point in an
/// async function — there are no disposal windows, no `ref.mounted` guards,
/// and no timing-dependent failures.
///
/// ## Concurrent calls
///
/// [isConnected] may be called concurrently by multiple repository methods
/// (e.g. when two requests fire in parallel). [ReachabilityCache] provides
/// implicit concurrency control: both callers will run the adapter check
/// independently (cheap), but at most one fresh probe will run during any
/// given TTL window — subsequent callers hit the cache. No explicit lock or
/// mutex is needed.

@ProviderFor(ConnectivityService)
final connectivityServiceProvider = ConnectivityServiceProvider._();

/// Stateless keepAlive service that runs all connectivity checks for the app.
///
/// ## Why a keepAlive Notifier instead of a FutureProvider (`@riverpod`)
///
/// The previous implementation used `@riverpod Future<bool> isConnected(...)`
/// — an autoDispose FutureProvider accessed via `ref.read()`. That pattern
/// has a fundamental lifecycle mismatch:
///
/// `ref.read()` does NOT add a persistent listener. With no active listeners,
/// Riverpod schedules the autoDispose provider for disposal on the next event
/// loop iteration. Because `isConnected` contained two `await` gaps
/// (`checkConnectivity()` + the reachability probe), the provider was
/// frequently disposed *between* those awaits — before the async computation
/// finished. Once disposed, `ref.mounted` became `false`, causing the function
/// to return `false` early and throw a spurious [NetworkFailure] even on a
/// fully working connection.
///
/// A `keepAlive: true` Notifier's `ref` is valid for the entire app lifetime.
/// Methods on this notifier can safely call `ref.read()` at any point in an
/// async function — there are no disposal windows, no `ref.mounted` guards,
/// and no timing-dependent failures.
///
/// ## Concurrent calls
///
/// [isConnected] may be called concurrently by multiple repository methods
/// (e.g. when two requests fire in parallel). [ReachabilityCache] provides
/// implicit concurrency control: both callers will run the adapter check
/// independently (cheap), but at most one fresh probe will run during any
/// given TTL window — subsequent callers hit the cache. No explicit lock or
/// mutex is needed.
final class ConnectivityServiceProvider
    extends $NotifierProvider<ConnectivityService, void> {
  /// Stateless keepAlive service that runs all connectivity checks for the app.
  ///
  /// ## Why a keepAlive Notifier instead of a FutureProvider (`@riverpod`)
  ///
  /// The previous implementation used `@riverpod Future<bool> isConnected(...)`
  /// — an autoDispose FutureProvider accessed via `ref.read()`. That pattern
  /// has a fundamental lifecycle mismatch:
  ///
  /// `ref.read()` does NOT add a persistent listener. With no active listeners,
  /// Riverpod schedules the autoDispose provider for disposal on the next event
  /// loop iteration. Because `isConnected` contained two `await` gaps
  /// (`checkConnectivity()` + the reachability probe), the provider was
  /// frequently disposed *between* those awaits — before the async computation
  /// finished. Once disposed, `ref.mounted` became `false`, causing the function
  /// to return `false` early and throw a spurious [NetworkFailure] even on a
  /// fully working connection.
  ///
  /// A `keepAlive: true` Notifier's `ref` is valid for the entire app lifetime.
  /// Methods on this notifier can safely call `ref.read()` at any point in an
  /// async function — there are no disposal windows, no `ref.mounted` guards,
  /// and no timing-dependent failures.
  ///
  /// ## Concurrent calls
  ///
  /// [isConnected] may be called concurrently by multiple repository methods
  /// (e.g. when two requests fire in parallel). [ReachabilityCache] provides
  /// implicit concurrency control: both callers will run the adapter check
  /// independently (cheap), but at most one fresh probe will run during any
  /// given TTL window — subsequent callers hit the cache. No explicit lock or
  /// mutex is needed.
  ConnectivityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityServiceHash();

  @$internal
  @override
  ConnectivityService create() => ConnectivityService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$connectivityServiceHash() =>
    r'f81c1f636f90bfeecb17f8448f62c43fcde1a637';

/// Stateless keepAlive service that runs all connectivity checks for the app.
///
/// ## Why a keepAlive Notifier instead of a FutureProvider (`@riverpod`)
///
/// The previous implementation used `@riverpod Future<bool> isConnected(...)`
/// — an autoDispose FutureProvider accessed via `ref.read()`. That pattern
/// has a fundamental lifecycle mismatch:
///
/// `ref.read()` does NOT add a persistent listener. With no active listeners,
/// Riverpod schedules the autoDispose provider for disposal on the next event
/// loop iteration. Because `isConnected` contained two `await` gaps
/// (`checkConnectivity()` + the reachability probe), the provider was
/// frequently disposed *between* those awaits — before the async computation
/// finished. Once disposed, `ref.mounted` became `false`, causing the function
/// to return `false` early and throw a spurious [NetworkFailure] even on a
/// fully working connection.
///
/// A `keepAlive: true` Notifier's `ref` is valid for the entire app lifetime.
/// Methods on this notifier can safely call `ref.read()` at any point in an
/// async function — there are no disposal windows, no `ref.mounted` guards,
/// and no timing-dependent failures.
///
/// ## Concurrent calls
///
/// [isConnected] may be called concurrently by multiple repository methods
/// (e.g. when two requests fire in parallel). [ReachabilityCache] provides
/// implicit concurrency control: both callers will run the adapter check
/// independently (cheap), but at most one fresh probe will run during any
/// given TTL window — subsequent callers hit the cache. No explicit lock or
/// mutex is needed.

abstract class _$ConnectivityService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
