import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:tokenshell_riverpod/core/logging/log_level_policy.dart';

/// Forwards every error/exception Talker captures via [Talker.handle] to
/// Sentry, so the two systems never drift apart.
///
/// Without this, only errors that happen to ALSO pass through
/// [FlutterError.onError] / [PlatformDispatcher.onError] (chained in
/// [setupGlobalErrorHandling] below) would ever reach Sentry. Every error
/// that's already caught locally and passed straight to `talker.handle()`
/// — `FailureMapper`, `ConnectivityService.isConnected()`,
/// `AuthInterceptor`, and any future call site — would stay Talker-only
/// and never leave the device. [onLog] is deliberately NOT overridden:
/// routine `.info()` / `.warning()` / `.debug()` calls are not errors and
/// would just spam Sentry with non-actionable noise.
///
/// Added as part of the production-readiness audit, 25 Jun 2026 (RC-1 —
/// no crash reporter was integrated at all before this).
class _SentryForwardingObserver extends TalkerObserver {
  @override
  void onError(TalkerError err) {
    unawaited(Sentry.captureException(err.error, stackTrace: err.stackTrace));
    super.onError(err);
  }

  @override
  void onException(TalkerException err) {
    unawaited(
      Sentry.captureException(err.exception, stackTrace: err.stackTrace),
    );
    super.onException(err);
  }
}

/// Single source of truth for the app's [Talker] instance.
///
/// This used to be a top-level variable declared directly in `main.dart`,
/// which meant every Core file that needed logging (`dio_client.dart`,
/// `failure_mapper.dart`, ...) had to import `main.dart` to reach it — a
/// Core layer file depending on the App entrypoint, backwards from how
/// dependencies should flow, and it made those files impossible to unit
/// test without dragging in the entire app bootstrap sequence.
///
/// Exposed two ways on purpose:
/// - [talker] — a raw top-level instance, kept because Flutter's global
///   error handlers ([setupGlobalErrorHandling]) run in `main()` before
///   `ProviderScope` is mounted — there is no [Ref] to read from at that
///   point yet.
/// - [talkerProvider] — what every other file should use instead. Reading
///   it through a `Ref` keeps call sites mockable in tests instead of
///   reaching for this global directly.
///
/// `settings` and `observer` come from [LogLevelPolicy] and
/// [_SentryForwardingObserver] respectively (added 25 Jun 2026) — neither
/// existed when this file only read `TalkerSettings()` with no
/// environment awareness and no link to a remote crash reporter.
final Talker talker = TalkerFlutter.init(
  settings: LogLevelPolicy.talkerSettings,
  observer: _SentryForwardingObserver(),
);

/// Riverpod access point for [talker]. `keepAlive: true` because logging
/// has no natural "scope" to dispose with — it's needed for the entire app
/// lifetime, same reasoning as the `Connectivity` plugin provider.
///
/// This is the one deliberate, approved exception to "app-wide providers
/// use `@riverpod` codegen" (see `failure_mapper.dart` and
/// `auth_interceptor.dart` for the converted cases): [talker] must already
/// exist before `ProviderScope` is mounted, so there is no generated
/// `Ref`-based access point this could be built from in the first place —
/// this stays a manually-declared `Provider<Talker>` on purpose, not by
/// oversight.
final Provider<Talker> talkerProvider = Provider<Talker>(
  (ref) => talker,
  name: 'talkerProvider',
);

/// Wires Flutter's global error hooks to [talker], so uncaught errors are
/// visible in the Talker console instead of only the raw system log (or,
/// for `PlatformDispatcher.onError`, disappearing silently):
/// - [FlutterError.onError] — uncaught errors during the framework's own
///   build/layout/paint pipeline.
/// - [PlatformDispatcher.onError] — uncaught async errors outside any
///   Flutter-managed [Zone] (e.g. inside a bare `Future` not awaited by
///   the framework).
///
/// Call this once, at the very top of `main()`, before `runApp` — both
/// hooks need to be set before anything can throw.
///
/// ## Call-order safety with SentryFlutter.init() (added 25 Jun 2026)
///
/// `SentryFlutter.init()` (see `sentry_bootstrap.dart`) ALSO assigns
/// [FlutterError.onError] and [PlatformDispatcher.onError] internally, to
/// auto-capture Flutter framework errors. Whichever of the two init calls
/// runs second would normally clobber the other's handler outright —
/// assignment to these fields replaces the previous value, it doesn't
/// compose with it.
///
/// This function avoids that by capturing whatever handler is already
/// registered *before* overwriting it, then calling that captured handler
/// from inside the new one. That makes the fix order-independent: it
/// works whether `setupGlobalErrorHandling()` runs before or after
/// `SentryFlutter.init()` in `main.dart` — `main.dart` still documents a
/// specific call order for clarity, but a future reordering mistake won't
/// silently drop either Talker or Sentry's error capture.
void setupGlobalErrorHandling() {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'FlutterError.onError');
    previousOnError?.call(details);
  };

  final previousPlatformOnError = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    talker.handle(error, stackTrace, 'PlatformDispatcher.onError');
    return previousPlatformOnError?.call(error, stackTrace) ?? true;
  };
}
