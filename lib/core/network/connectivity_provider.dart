// dart run build_runner build --delete-conflicting-outputs
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';

part 'connectivity_provider.g.dart';

// ── Raw connectivity stream ────────────────────────────────────────────────────

/// Provides the [Connectivity] plugin singleton.
@Riverpod(keepAlive: true)
Connectivity connectivity(Ref ref) => Connectivity();

/// Stream provider that emits the current [ConnectivityResult] list
/// whenever the device's network status changes.
///
/// Consumers can `watch` this provider to reactively rebuild on connectivity
/// changes, or `read` it for one-shot checks.
@riverpod
Stream<List<ConnectivityResult>> connectivityStream(Ref ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
}

// ── One-shot connectivity check ───────────────────────────────────────────────

/// Returns `true` if at least one active connection is available.
bool _hasConnection(List<ConnectivityResult> results) {
  return results.any((r) => r != ConnectivityResult.none);
}

/// Checks the current connectivity status once and returns `true` if the
/// device has an active network connection.
///
/// Prefer [connectivityStreamProvider] for reactive UI; use this utility
/// inside repository methods before making network requests.
@riverpod
Future<bool> isConnected(Ref ref) async {
  final results = await ref.read(connectivityProvider).checkConnectivity();
  return _hasConnection(results);
}

// ── Guard utility ─────────────────────────────────────────────────────────────

/// Throws a [NetworkFailure] if the device has no active connection.
///
/// Use this at the top of remote data source methods to fail fast without
/// initiating an HTTP request that is guaranteed to time out.
///
/// ```dart
/// await requiresConnectivity(ref);
/// final response = await _api.getPosts();
/// ```
Future<void> requiresConnectivity(Ref ref) async {
  final connected = await ref.read(isConnectedProvider.future);
  if (!connected) {
    throw const NetworkFailure();
  }
}
