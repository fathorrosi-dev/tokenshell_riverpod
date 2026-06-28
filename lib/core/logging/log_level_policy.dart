import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:tokenshell_riverpod/core/env/app_flavor.dart';

/// Single source of truth for how verbose Talker is, and what HTTP traffic
/// detail [TalkerDioLogger] is allowed to print — gated by [AppFlavor].
///
/// ## Why a plain class of static getters, not a Riverpod provider
///
/// [talker] (see `talker_provider.dart`) is a top-level global var
/// constructed BEFORE `ProviderScope` mounts — `setupGlobalErrorHandling()`
/// in `main.dart` needs it to exist before `runApp()` is even called. A
/// Riverpod provider requires a `Ref`, which doesn't exist yet at that
/// point. This class reads [currentFlavor] directly instead — the same
/// compile-time `String.fromEnvironment` signal [appFlavorProvider] wraps
/// — so it stays usable from both `talker_provider.dart`'s global-var
/// construction site AND `dio_client.dart`'s provider body, with no `Ref`
/// required at either call site.
///
/// ## Root cause this closes (production-readiness audit, 25 Jun 2026)
///
/// `app_flavor.dart`'s doc comment used to describe exactly this kind of
/// gating as an illustrative example
/// (`if (flavor != AppFlavor.prod) talker.verbose(...)`) that was never
/// actually wired into `talker_provider.dart` or `dio_client.dart` — two
/// separate root causes from the same review (RC-3: `TalkerDioLogger` had
/// zero settings, logging full request/response data in every build mode;
/// RC-4: verbose Talker logging stayed on in `AppFlavor.prod` despite the
/// doc comment describing the opposite). Consolidated into one file
/// rather than two separate ad-hoc fixes, since both share the same root
/// cause: no single place read [currentFlavor] to decide logging
/// behavior at all.
final class LogLevelPolicy {
  const LogLevelPolicy._(); // Static-only — never instantiate.

  static bool get _isProd => currentFlavor() == AppFlavor.prod;

  /// [TalkerSettings] for the main [Talker] instance (`talker_provider.dart`).
  ///
  /// `useConsoleLogs: false` in prod — there is no attached console on a
  /// shipped release build to read this from, so printing it is pure
  /// overhead with zero benefit. `useHistory` stays `true` in every
  /// flavor: it's what lets `talker.handle()` carry recent context, it's
  /// in-memory only (never written to disk), and it feeds the Sentry
  /// forwarding observer set up alongside this — turning it off in prod
  /// would silently weaken that pipeline too.
  static TalkerSettings get talkerSettings => TalkerSettings(
    useConsoleLogs: !_isProd,
  );

  /// Headers that must never be printed in ANY build mode, not just prod.
  ///
  /// Permanent, not flavor-gated — `Authorization` and `X-Api-Key` carry
  /// live credentials the moment a real login feature starts populating
  /// `accessTokenReaderProvider` (see `auth_interceptor.dart`). Waiting
  /// until "prod only" to redact them would mean dev/staging builds —
  /// which are also installed on real test devices, not just emulators —
  /// print real session tokens to console.
  static const Set<String> hiddenDioHeaders = {'Authorization', 'X-Api-Key'};

  /// [TalkerDioLoggerSettings] for the `TalkerDioLogger` interceptor in
  /// `dio_client.dart`.
  ///
  /// Body data (`printRequestData` / `printResponseData`) is the
  /// highest-volume, lowest-value-per-byte part of this log in prod —
  /// still genuinely useful in dev/staging for debugging a failing
  /// request, but not worth shipping into every release build's console
  /// for an API surface that isn't guaranteed to stay PII-free as
  /// features grow beyond today's public-mock-API starter state.
  static TalkerDioLoggerSettings get dioLoggerSettings =>
      TalkerDioLoggerSettings(
        hiddenHeaders: hiddenDioHeaders,
        printRequestData: !_isProd,
        printResponseData: !_isProd,
      );
}
