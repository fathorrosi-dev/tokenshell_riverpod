// dart run build_runner build --delete-conflicting-outputs
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/network/connectivity_provider.dart';

part 'offline_provider.g.dart';

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
@Riverpod(keepAlive: true)
bool isOffline(Ref ref) {
  return ref.watch(connectivityStreamProvider).maybeWhen(
    // Treat "all adapters report none" as offline. A device with any
    // active adapter (WiFi, mobile, ethernet) is considered online here —
    // actual reachability is confirmed by the two-tier check in
    // ConnectivityService.isConnected() at the repository call site.
    data: (results) => results.every((r) => r == ConnectivityResult.none),
    // Unknown / error state → assume online to avoid flashing the offline
    // banner on cold start before the first stream event arrives. If the
    // device is genuinely offline the first real data event surfaces it
    // quickly with no noticeable delay.
    orElse: () => false,
  );
}
