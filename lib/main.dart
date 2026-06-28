import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'package:tokenshell_riverpod/app/app.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';
import 'package:tokenshell_riverpod/core/observability/observability.dart';

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  // `initSentry` wraps everything below in Sentry's own zone-guarded
  // `appRunner` — this is also what closes the "no runZonedGuarded around
  // runApp()" gap from the same audit (25 Jun 2026): Sentry's SDK already
  // installs the equivalent zone/error-capture machinery as part of this
  // call, so a second, separate `runZonedGuarded` wrapper here would be
  // redundant rather than additive. See `sentry_bootstrap.dart` for why
  // this needs to run FIRST, with the rest of bootstrap nested inside it.
  await initSentry(
    appRunner: () {
      // Runs AFTER SentryFlutter.init() above has already installed its
      // own FlutterError.onError / PlatformDispatcher.onError hooks — this
      // call captures and chains onto those (see its doc comment in
      // talker_provider.dart), so both Sentry's and Talker's error
      // capture stay active together rather than one silently
      // overwriting the other.
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
}
