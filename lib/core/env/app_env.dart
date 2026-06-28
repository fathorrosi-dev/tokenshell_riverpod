// dart run build_runner build --delete-conflicting-outputs
import 'package:envied/envied.dart';

part 'app_env.g.dart';

/// Application environment variables loaded at build time via [envied].
///
/// Values are read from the `.env` file at the project root (never committed).
/// Developers must copy `.env.example` → `.env` and fill in real values.
///
/// [obfuscate: true] on sensitive fields prevents the raw string from
/// appearing in the compiled binary's symbol table.
///
/// ── Multiple environments (dev/staging/prod) ──────────────────────────────
///
/// [AppEnv] itself stays single-source-of-truth on purpose — `@Envied`'s
/// `path:` is a compile-time literal, so it can't switch at runtime. The
/// low-cost, zero-change-here pattern: keep `.env.dev` / `.env.staging` /
/// `.env.prod` at the project root and copy whichever one applies to `.env`
/// as a build step (shell script or CI job) before `flutter build` /
/// `flutter run` — [AppEnv] just reads whatever `.env` happens to be in
/// place, exactly as it does today.
///
/// That covers *which values* (base URL, API key) a build uses. For
/// branching *app behavior* on which environment is active (e.g. a
/// "STAGING" debug banner, disabling crash reporting outside prod), see
/// [AppFlavor] in `app_flavor.dart` — a compile-time enum resolved from
/// `--dart-define=APP_FLAVOR=<value>` that is independent of this class.
@Envied(path: '.env')
abstract final class AppEnv {
  /// Base URL for the REST API (e.g. https://jsonplaceholder.typicode.com).
  @EnviedField(
    varName: 'BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  )
  static const String baseUrl = _AppEnv.baseUrl;

  /// Optional API key sent as the `X-Api-Key` header (see `dio_client.dart`
  /// — deliberately not `Authorization`, which is reserved for the
  /// per-user token from `AuthInterceptor`).
  /// Obfuscated so the raw value is not stored as a plain string in the binary.
  @EnviedField(varName: 'API_KEY', defaultValue: '', obfuscate: true)
  static final String apiKey = _AppEnv.apiKey;

  /// Sentry DSN, read by `core/observability/sentry_bootstrap.dart`.
  ///
  /// NOT [obfuscate]d, unlike [apiKey] above — a Sentry DSN is a
  /// write-only ingest endpoint, not a credential that grants read access
  /// to anything. Sentry's own docs treat DSNs as safe to ship in a client
  /// binary (anyone who extracts it can only submit garbage events to your
  /// project, which Sentry's own rate-limiting / spike protection already
  /// guards against) — it does not warrant the same protection as an API
  /// key that, if leaked, grants access to real backend data.
  ///
  /// Empty default so a developer who hasn't set up a Sentry project yet
  /// (or is running a local `flutter run`) doesn't get a build failure —
  /// `sentry_bootstrap.dart` treats an empty DSN as "Sentry disabled."
  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '', obfuscate: true)
  static String sentryDsn = _AppEnv.sentryDsn;
}
