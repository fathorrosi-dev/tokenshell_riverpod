import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:tokenshell_riverpod/core/env/app_env.dart';
import 'package:tokenshell_riverpod/core/env/app_flavor.dart';

/// Initializes Sentry and runs the app inside it via the `appRunner`
/// pattern Sentry's own docs recommend — this is what lets Sentry capture
/// errors that occur anywhere during `runApp()` and afterward, including
/// errors Sentry's own internal [FlutterError.onError] /
/// [PlatformDispatcher.onError] hooks pick up automatically.
///
/// ## Call order in `main.dart`
///
/// Call this FIRST, with the rest of bootstrap (including
/// `setupGlobalErrorHandling()` and `runApp()` itself) happening *inside*
/// [appRunner]. `SentryFlutter.init()` installs its own global error
/// hooks synchronously as part of running this function, before
/// [appRunner] is invoked — so by the time `setupGlobalErrorHandling()`
/// runs inside [appRunner], it captures Sentry's hooks as the "previous"
/// handler and chains onto them (see that function's doc comment in
/// `talker_provider.dart`). Reversing this order would still work
/// correctly thanks to that chaining, but keeping init→appRunner as a
/// single nested call is also just what every official Sentry Flutter
/// example does — no reason to deviate without one.
///
/// ## Disabled in local dev without a Sentry project
///
/// [AppEnv.sentryDsn] defaults to an empty string. Sentry's SDK treats a
/// missing/empty DSN as "do not send events" rather than throwing — so a
/// developer running `flutter run` locally without ever setting up a
/// `.env` entry for this still gets a working app, just with Sentry
/// effectively a no-op. No conditional branching needed here for that
/// case; it falls out of the SDK's own documented behavior.
Future<void> initSentry({required FutureOr<void> Function() appRunner}) {
  return SentryFlutter.init(
    (options) {
      options
        ..dsn = AppEnv.sentryDsn
        // Mirrors AppFlavor so Sentry's own environment filter (separate
        // from this app's --dart-define=APP_FLAVOR) lines up with the same
        // three values used everywhere else in this codebase.
        ..environment = currentFlavor().name
        // Full tracing in dev/staging — there's no production traffic
        // volume to worry about, and seeing every transaction is more
        // useful than sampling while iterating. Sampled in prod: capturing
        // every single transaction at real user volume costs Sentry quota
        // for marginal additional insight once you have enough samples to
        // see the shape of your latency distribution. 0.2 is a starting
        // point, not a permanent value — revisit once real prod traffic
        // volume is known.
        ..tracesSampleRate = currentFlavor() == AppFlavor.prod ? 0.2 : 1.0;

      // Deliberately NOT setting `sendDefaultPii = true`. Sentry's SDK
      // defaults this to `false` — i.e. headers/cookies/IP are already
      // excluded from captured events and breadcrumbs out of the box.
      // Leaving the default alone here is itself the security-conscious
      // choice; explicitly writing `false` would just restate the
      // default, so it's left unset rather than added for the sake of
      // looking thorough.
    },
    appRunner: appRunner,
  );
}
