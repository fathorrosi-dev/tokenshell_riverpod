# Package Decisions

A running log of every third-party package this project depends on that
isn't part of the original stack defaults, recorded the same way
`flutter-arch-reviewer`'s New Package Approval Process expects: purpose,
why the existing stack can't cover it, benefits, drawbacks, maintenance
impact, long-term risk, and a final recommendation.

Every entry here should be added **before** (or, for already-shipped
packages being retroactively documented, immediately after discovery
during) the package lands in `pubspec.yaml` — so any future architecture
review never has to flag an ungoverned dependency again.

---

## package_info_plus

**Status:** Already in use — retroactively documented.
**Used in:** `lib/core/di/package_info_provider.dart`

| Field | Detail |
| --- | --- |
| **Purpose** | Read platform-resolved app metadata at runtime — version, build number, package name, app name — for display in Settings → About. |
| **Alternative using existing stack** | None. `AppEnv` (envied) only reads compile-time values from a developer-authored `.env` file; it has no visibility into the actual version/build number Flutter resolves from `pubspec.yaml` + the platform manifest (`AndroidManifest.xml` / `Info.plist`) at build time. No other approved package (`dio`, `shared_preferences`, `flutter_secure_storage`, `connectivity_plus`, `talker`) touches platform app metadata at all. |
| **Why existing stack is insufficient** | This is platform-channel-only information — Dart code cannot read it without either a native platform channel or a plugin that wraps one. Hand-rolling a `MethodChannel` for a single read-only value across Android/iOS/web would be strictly more maintenance burden than depending on the official Flutter-community plugin built for exactly this. |
| **Benefits** | Single-purpose, official `flutter.dev`-maintained plugin; one call (`PackageInfo.fromPlatform()`) covers all supported platforms; already wrapped behind `packageInfoProvider`, so any future replacement stays a one-file change. |
| **Drawbacks** | Adds one more platform-channel plugin to keep in sync with Flutter SDK upgrades; trivial binary size cost. |
| **Maintenance impact** | Low — narrow API surface, stable for years, no business logic depends on its internals beyond four read-only string/int fields. |
| **Long-term risk** | Low. |
| **Recommendation** | **Required.** Approved for continued use — add to the project's approved-packages reference alongside the rest of the stack. |

---

## sentry_flutter, sentry_dio, sentry_dart_plugin

**Status:** Already in use — retroactively documented (found during the
M3/shadcn-removal architecture review, 05 Aug 2026 — a gap in this project's
own governance process being closed, the same way `package_info_plus` was).
**Used in:** `lib/main.dart`, `lib/core/observability/sentry_bootstrap.dart`,
`lib/core/observability/sentry_user_scope.dart`,
`lib/core/observability/observability.dart`,
`lib/core/network/dio_client.dart`,
`lib/core/network/interceptors/auth_interceptor.dart`

| Field | Detail |
| --- | --- |
| **Purpose** | Crash reporting and application performance monitoring (APM) — `sentry_flutter` captures uncaught Dart/Flutter errors and performance traces; `sentry_dio` instruments the shared `Dio` client so network spans show up inside those traces; `sentry_dart_plugin` is a build-time-only dev dependency that uploads debug symbols so stack traces from release builds are human-readable in the Sentry dashboard. |
| **Alternative using existing stack** | `talker` (already approved) gives structured, colorized local/in-app logging, but it is a local logging façade only — it has no remote ingestion, aggregation, alerting, or release-health dashboard. It solves a different problem than crash reporting. |
| **Why existing stack is insufficient** | Nothing else in the approved stack ships errors off-device. Talker logs are only as durable as the device they're generated on; a crash a user never reports is invisible without a remote crash reporter. |
| **Benefits** | Industry-standard crash/APM tooling; `sentry_dio`'s Dio integration means network failures are automatically correlated with the request that caused them instead of needing manual breadcrumbing; already wired to forward through `_SentryForwardingObserver` alongside Talker (see `observability.dart`), so the two systems stay in sync rather than being two independent, divergent sources of truth. |
| **Drawbacks** | Third-party data leaves the device (mitigated by `sentry_user_scope.dart` controlling what user context is attached); `sentry_dart_plugin`'s symbol-upload step is one more thing that can fail a release build if misconfigured; adds meaningful binary size versus the logging-only alternative. |
| **Maintenance impact** | Low-to-moderate — stable, actively maintained by Sentry; the documented zone-safety fix for `Sentry.runZonedGuarded` on Flutter Web (see `sentry_bootstrap.dart`) is the one non-trivial integration detail this project has had to carry itself. |
| **Long-term risk** | Low. |
| **Recommendation** | **Required.** Approved for continued use — add to the project's approved-packages reference alongside the rest of the stack. |

---

<!--
Next entry template:

## <package_name>

**Status:** <Proposed | Already in use — retroactively documented>
**Used in:** <file path(s)>

| Field | Detail |
|---|---|
| **Purpose** | |
| **Alternative using existing stack** | |
| **Why existing stack is insufficient** | |
| **Benefits** | |
| **Drawbacks** | |
| **Maintenance impact** | |
| **Long-term risk** | |
| **Recommendation** | Required / Optional / Not Worth It |
-->
