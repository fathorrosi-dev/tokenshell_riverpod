import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:tokenshell_riverpod/app/app.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';
import 'package:tokenshell_riverpod/core/observability/observability.dart';

Future<void> main() async {
  // FIX (04 Jul 2026): the previous version called
  // `SentryWidgetsFlutterBinding.ensureInitialized()` here, un-wrapped, then
  // relied on `initSentry`'s internal `appRunner` zone to cover `runApp()`.
  // That comment claimed this "closed the zone gap" — it didn't:
  // `SentryFlutter.init(appRunner: ...)` only REUSES an existing zone
  // instead of creating its own nested one when it detects it's already
  // running inside a custom zone (sentry_flutter #2088). Calling
  // `ensureInitialized()` directly in `main()`'s default zone doesn't
  // count as "inside a custom zone", so the binding ended up initialized
  // in the root zone while `runApp()` ran inside a *different*,
  // Sentry-created zone — exactly the split Flutter's `debugCheckZone`
  // detects and reports as "Zone mismatch" on `runApp`. It was invisible
  // on mobile (same split existed there, just never surfaced) and
  // guaranteed on web because Flutter's web zone-check path always
  // exercises `debugCheckZone`.
  //
  // `Sentry.runZonedGuarded` — Sentry's own documented pattern for this
  // exact "need ensureInitialized() before SentryFlutter.init()" case —
  // fixes it by giving `ensureInitialized()` and `appRunner`/`runApp()` the
  // SAME explicit zone up front, so `SentryFlutter.init` reuses it instead
  // of nesting a second one.
  Sentry.runZonedGuarded(
    () async {
      SentryWidgetsFlutterBinding.ensureInitialized();

      // `initSentry` wraps the rest of bootstrap in `appRunner`. See
      // `sentry_bootstrap.dart` for why this needs to run FIRST, with the
      // rest of bootstrap nested inside it.
      await initSentry(
        appRunner: () {
          // Runs AFTER SentryFlutter.init() above has already installed
          // its own FlutterError.onError / PlatformDispatcher.onError
          // hooks — this call captures and chains onto those (see its doc
          // comment in talker_provider.dart), so both Sentry's and
          // Talker's error capture stay active together rather than one
          // silently overwriting the other.
          setupGlobalErrorHandling();

          runApp(
            ProviderScope(
              observers: [
                TalkerRiverpodObserver(
                  talker: talker,
                  settings: const TalkerRiverpodLoggerSettings(
                    printStateFullData: false,
                  ),
                ),
              ],
              child: const App(),
            ),
          );
        },
      );
    },
    // Last-resort net for errors raised in this zone before Sentry's own
    // hooks are attached, or outside any Flutter-managed callback (e.g. a
    // bare unawaited Future rejecting during bootstrap). Sentry's zone
    // already reports these on its own; forwarding to Talker too keeps
    // this path visible in the local Talker console instead of being
    // Sentry-only, consistent with every other error source in the app.
    (error, stackTrace) =>
        talker.handle(error, stackTrace, 'Uncaught zone error'),
  );
}
