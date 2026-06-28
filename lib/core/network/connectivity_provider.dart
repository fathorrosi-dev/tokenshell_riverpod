// dart run build_runner build --delete-conflicting-outputs
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tokenshell_riverpod/core/env/app_env.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';

part 'connectivity_provider.freezed.dart';
part 'connectivity_provider.g.dart';

// ── Raw connectivity stream ────────────────────────────────────────────────────

/// Provides the [Connectivity] plugin singleton.
@Riverpod(keepAlive: true)
Connectivity connectivity(Ref ref) => Connectivity();

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
@Riverpod(keepAlive: true)
Stream<List<ConnectivityResult>> connectivityStream(Ref ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
}

// ── One-shot connectivity check ───────────────────────────────────────────────

/// Returns `true` if at least one active connection is available.
bool _hasConnection(List<ConnectivityResult> results) {
  return results.any((r) => r != ConnectivityResult.none);
}

// ── Reachability probe ────────────────────────────────────────────────────────

/// Endpoint used purely to confirm real internet access, not just an
/// active network adapter.
///
/// ## Why this is the app's own backend, not a generic endpoint like
/// `gstatic.com/generate_204`
///
/// An earlier version of this probe pointed at Google's
/// `generate_204` — the same lightweight endpoint Android itself uses
/// for captive-portal detection. That's a reasonable default when an app
/// has no backend of its own yet, but it has a real failure mode this
/// project actually hit once pagination started exercising this probe on
/// every `loadMore()` call instead of once per full list load: some
/// networks (corporate firewalls, certain regions/ISPs) block or
/// deprioritize `gstatic.com` specifically, while the app's *actual*
/// backend is fully reachable — every guarded repository call would then
/// incorrectly report "No internet connection" even though the user's
/// internet works fine for everything the app actually needs.
///
/// Probing the app's own [AppEnv.baseUrl] instead removes that entire
/// risk class: it answers "can this app reach the backend it actually
/// needs," which is the only question that matters here, and is also
/// guaranteed not to be blocked independently of the app's own API.
/// `/posts/1` is the lightest real resource on jsonplaceholder's API —
/// swap the path if you point [AppEnv.baseUrl] at a different backend
/// with its own dedicated health-check route.
const String _reachabilityProbeUrl = '${AppEnv.baseUrl}/posts/1';

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
@Riverpod(keepAlive: true)
Dio probeDio(Ref ref) {
  return Dio()..options.connectTimeout = const Duration(seconds: 5);
}

/// Confirms actual internet reachability, not just an active adapter.
///
/// `connectivity_plus` alone only reports whether WiFi/cellular is "on" —
/// a device can report connected while sitting behind a captive portal or
/// a router with no working upstream. This closes that gap.
///
/// ## Why `GET`, not `HEAD`
///
/// An earlier version of this probe used `dio.head<void>(...)`. That was
/// never actually verified against [AppEnv.baseUrl]'s specific hosting —
/// unlike `gstatic.com/generate_204`, which is purpose-built and
/// guaranteed to support `HEAD`, an arbitrary backend (including
/// jsonplaceholder's own hosting/reverse-proxy setup) may not handle
/// `HEAD` the same way it handles `GET`, and could legitimately answer it
/// with a non-2xx status regardless of whether the backend is actually
/// reachable. `GET` is the one HTTP method this app has already proven
/// works against this exact host — every other repository call already
/// succeeds with it — so probing with the same method removes an entire
/// "does this endpoint even support this verb" uncertainty rather than
/// trading it for a smaller response payload.
///
/// Accepts any 2xx status, not just an exact code — different backends
/// legitimately answer a successful request with 200, 204, or another
/// 2xx depending on their own implementation.
///
/// Pure function that accepts an injected [dio] — callers substitute a mock
/// client in tests without needing to touch the Riverpod graph. Lets any
/// [DioException] propagate rather than catching it here: this function
/// stays a plain bool-returning probe, and [ConnectivityService.isConnected]
/// — the only caller — is where [Talker] is actually available to log *why*
/// a probe failed instead of collapsing every failure mode (timeout, DNS,
/// refused connection, non-2xx response) into the same silent `false`.
Future<bool> _hasRealInternetAccess(Dio dio) async {
  final response = await dio.get<void>(_reachabilityProbeUrl);
  final status = response.statusCode ?? 0;
  return status >= 200 && status < 300;
}

// ── Reachability cache ────────────────────────────────────────────────────────
//
// [ConnectivityService.isConnected] used to call [_hasRealInternetAccess] on
// *every single* invocation — meaning every repository method guarded by
// [requiresConnectivity] paid for an extra network round trip (up to the
// probe's connectTimeout worth of latency in the worst case) on top of
// its real request, every time.
//
// The fix only caches the *expensive* part (the network probe) — the
// adapter check via [_hasConnection] stays uncached since it's local and
// effectively free.
//
// Success and failure are cached for different durations on purpose —
// see [_reachabilitySuccessCacheTtl] and [_reachabilityFailureCacheTtl].

/// How long a *successful* probe result is trusted before re-checking.
///
/// 30 seconds — was 8 in an earlier version. Pagination's `loadMore()`
/// calls [requiresConnectivity] on every page fetch, not just once per
/// screen the way a single full-list load used to; 8 seconds meant a user
/// scrolling through several pages in under a minute could trigger a
/// handful of fresh probes in that same short session. 30 seconds cuts
/// that frequency dramatically while staying short enough that a genuine
/// connectivity loss is still caught well within the same user session.
const Duration _reachabilitySuccessCacheTtl = Duration(seconds: 30);

/// How long a *failed* probe result is trusted before re-checking.
///
/// Deliberately much shorter than [_reachabilitySuccessCacheTtl], not the
/// same value. Caching a failure for as long as a success would mean one
/// bad probe — a single timed-out request, not necessarily an actual outage
/// — reports "no internet" on every guarded call for the *entire* TTL
/// window, even if the network recovers immediately afterward. That's
/// exactly backwards from what a cache should do here: the cost of
/// re-probing too often while genuinely offline is irrelevant (it just
/// fails fast again), so there is no symmetric reason to trust a failure
/// for as long as a success.
const Duration _reachabilityFailureCacheTtl = Duration(seconds: 3);

/// Holds the result of the last reachability probe alongside when it ran,
/// so [ReachabilityCache] can decide whether that result is still fresh
/// enough to reuse instead of probing again.
///
/// Freezed — was a hand-written mutable class (audited 25 Jun 2026). Every
/// other state object in Core (see [Failure]) is immutable via Freezed;
/// this was the one exception, with no value/equality semantics and no
/// `copyWith` if a field is ever added. The private constructor + factory
/// pair below mirrors [Failure]'s pattern, which is what lets [isStale]
/// keep living as a plain getter alongside the generated fields.
@freezed
abstract class ProbeResult with _$ProbeResult {

  const factory ProbeResult({
    required bool result,
    required DateTime checkedAt,
  }) = _ProbeResult;
  
  const ProbeResult._();

  /// Whichever TTL applies to [result] — see [_reachabilitySuccessCacheTtl]
  /// and [_reachabilityFailureCacheTtl] for why these are deliberately
  /// different durations, not one shared value.
  bool get isStale {
    final ttl = result
        ? _reachabilitySuccessCacheTtl
        : _reachabilityFailureCacheTtl;
    return DateTime.now().difference(checkedAt) > ttl;
  }
}

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
@Riverpod(keepAlive: true)
class ReachabilityCache extends _$ReachabilityCache {
  @override
  ProbeResult? build() => null; // Initially no cached result.

  /// The most recently cached probe result, or `null` if no probe has
  /// run yet or the cache was cleared after a connectivity loss.
  ProbeResult? get latest => state;

  /// Records the result of a fresh reachability probe.
  ///
  /// Exposed as a Dart setter so call sites read naturally:
  /// `cacheNotifier.latest = ProbeResult(...)`.
  set latest(ProbeResult value) => state = value;

  /// Clears the cache when the adapter loses its connection.
  ///
  /// Called by [ConnectivityService.isConnected] on adapter-down so that
  /// reconnect always triggers a fresh probe instead of waiting out the
  /// stale TTL window from when the device was last online.
  void clear() => state = null;
}

// ── Connectivity service ──────────────────────────────────────────────────────

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
@Riverpod(keepAlive: true)
class ConnectivityService extends _$ConnectivityService {
  @override
  void build() {}

  /// Checks the current connectivity status once and returns `true` only if
  /// the device both has an active network adapter AND can actually reach
  /// the internet.
  ///
  /// The network-adapter check runs fresh every call (cheap, local). The
  /// internet-reachability probe is reused from [ReachabilityCache] when
  /// it's not yet stale, and only re-run otherwise — see
  /// [_reachabilitySuccessCacheTtl] / [_reachabilityFailureCacheTtl] for
  /// why these TTLs are deliberately different values.
  ///
  /// Prefer [connectivityStreamProvider] for reactive UI; use this via
  /// [requiresConnectivity] inside repository methods before network requests.
  Future<bool> isConnected() async {
    final connectivity = ref.read(connectivityProvider);
    final cacheNotifier = ref.read(reachabilityCacheProvider.notifier);
    final dio = ref.read(probeDioProvider);
    final talker = ref.read(talkerProvider)
      // debug, not info — this fires on EVERY isConnected() call, including
      // every cache hit during aggressive pagination (audited 25 Jun 2026).
      // At `info` it drowned out the genuinely rare events below (adapter
      // down, fresh probe ran, probe failed) in normal-mode log output.
      // `log_level_policy.dart` already filters `debug` out of
      // AppFlavor.prod, so this also means less noise to ship in release.
      ..debug('isConnected: check started');

    // ── Adapter check ─────────────────────────────────────────────────────
    final results = await connectivity.checkConnectivity();

    if (!_hasConnection(results)) {
      // Logged at `warning`, not `handle` — this isn't an exception, it's
      // `connectivity_plus` itself reporting no active adapter. Worth
      // seeing the raw `results` value when this fires: a consistently
      // wrong report here (adapter genuinely active, but every entry in
      // `results` is `ConnectivityResult.none`) points at a
      // `connectivity_plus`/platform-level issue rather than anything in
      // the reachability probe below, which never even runs in that case.
      talker.warning('isConnected: no active network adapter — $results');
      // No adapter connection means any cached "reachable" result is now
      // meaningless — drop it so the next reconnect forces a fresh probe
      // instead of waiting out the rest of the TTL window.
      cacheNotifier.clear();
      return false;
    }

    final cached = ref.read(reachabilityCacheProvider);
    if (cached != null && !cached.isStale) {
      // Previously the one remaining silent path: a cached `false` from an
      // earlier failed probe would return here with zero trace in the log,
      // indistinguishable from a fresh failure.
      //
      // debug, not info (downgraded 25 Jun 2026) — reusing a cache is
      // normal, expected behavior, not a problem by itself, and this path
      // fires on every guarded repository call during a cache-hit window
      // (very often under pagination). Still worth keeping at SOME level
      // for diagnosing why a failure feels "stuck" — just not a level
      // that ships in `AppFlavor.prod` console output by default.
      talker.debug('isConnected: reusing cached result (${cached.result})');
      return cached.result;
    }

    // ── Reachability probe ────────────────────────────────────────────────
    // Every path that can produce `reachable == false` below is logged —
    // this used to collapse three different failure modes (no adapter,
    // probe threw, probe got a non-2xx response) into the same silent
    // `false`, surfacing only as a generic "No internet connection" with
    // no way to tell which of those actually happened.
    talker.info(
      'isConnected: running a fresh probe against $_reachabilityProbeUrl',
    );
    bool reachable;
    try {
      reachable = await _hasRealInternetAccess(dio);
      if (!reachable) {
        talker.warning(
          'isConnected: probe got a response but not a 2xx status — '
          'treating $_reachabilityProbeUrl as unreachable.',
        );
      }
    } on DioException catch (error, stackTrace) {
      talker.handle(error, stackTrace, 'Reachability probe failed');
      reachable = false;
    }

    cacheNotifier.latest = ProbeResult(result: reachable, checkedAt: DateTime.now());
    return reachable;
  }
}

// ── Guard utility ─────────────────────────────────────────────────────────────

/// Returns `Right(unit)` if the device can reach the backend, or
/// `Left(NetworkFailure())` if no connection is available.
///
/// Use this at the top of repository methods to fail fast with an explicit
/// Either value rather than initiating an HTTP request that is guaranteed
/// to time out.
///
/// Changed from throw-based to Either-based in R-05 (27 Jun 2026) to align
/// with the established error propagation contract used by every other
/// Data/Domain layer method. See [ConnectivityGuard]'s doc comment for the
/// full rationale.
///
/// ```dart
/// // In a repository method:
/// final guard = await _connectivity();
/// if (guard case Left(:final value)) return Left(value);
/// // ... safe to make network request here
/// ```
Future<Either<NetworkFailure, Unit>> requiresConnectivity(Ref ref) async {
  final connected = await ref
      .read(connectivityServiceProvider.notifier)
      .isConnected();
  return connected ? const Right(unit) : const Left(NetworkFailure());
}
