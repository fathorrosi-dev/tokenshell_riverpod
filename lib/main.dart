import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:tokenshell_riverpod/app/app.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';
import 'package:tokenshell_riverpod/core/observability/observability.dart';

Future<void> main() async {
  // `Sentry.runZonedGuarded` — not a bare call sequence — is required so
  // that `ensureInitialized()` and `runApp()` execute in the SAME zone.
  //
  // Previously `SentryWidgetsFlutterBinding.ensureInitialized()` ran here,
  // directly in main()'s root zone, BEFORE `initSentry()`. On Flutter Web,
  // `SentryFlutter.init(appRunner: ...)` internally runs `appRunner` (and
  // therefore `runApp()`) inside its own zone — so the binding ended up
  // initialized in one zone while `runApp()` executed in another, tripping
  // Flutter's "Zone mismatch" assertion. Mobile/desktop targets don't hit
  // the same zone-sensitive binding path, which is why this only ever
  // showed up on web. `Sentry.runZonedGuarded` is Sentry's own documented
  // fix for exactly this: it establishes ONE zone up front, and
  // `SentryFlutter.init` detects it's already running inside a
  // Sentry-managed zone so it doesn't create a second, nested one.
  // See: https://github.com/getsentry/sentry-dart/issues/2063
  await Sentry.runZonedGuarded(
    () async {
      SentryWidgetsFlutterBinding.ensureInitialized();

      // `initSentry` wraps everything below in Sentry's own zone-guarded
      // `appRunner` — this is also what closes the "no runZonedGuarded
      // around runApp()" gap: Sentry's
      // SDK already installs the equivalent zone/error-capture machinery
      // as part of this call, so a second, separate `runZonedGuarded`
      // wrapper here would be redundant rather than additive. See
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
    (error, stackTrace) {
      // `Sentry.runZonedGuarded` already forwards uncaught errors caught at
      // this top (zone) level to Sentry automatically — this callback is
      // local supplementary handling only, so an error that occurs before
      // Talker/FlutterError.onError are wired up (or one Sentry itself
      // fails to transmit — DSN misconfigured, network down) still lands
      // somewhere visible instead of vanishing silently.
      talker.handle(error, stackTrace, 'Sentry.runZonedGuarded');
    },
  );
}
