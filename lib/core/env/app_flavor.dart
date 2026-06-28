// dart run build_runner build --delete-conflicting-outputs
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_flavor.g.dart';

/// Defines which environment the app was compiled for.
///
/// Set at build time via `--dart-define=APP_FLAVOR=<value>`. Three values
/// are supported: `dev` (default), `staging`, and `prod`.
///
/// ## AppFlavor vs AppEnv
///
/// - [AppEnv] controls *which values* a build uses: base URL, API key.
///   These are secrets read from `.env` files swapped in by CI before
///   each build.
/// - [AppFlavor] controls *how the app behaves* in that environment:
///   showing a staging banner, enabling verbose logging, gating analytics,
///   disabling crash reporting outside prod. Use this for runtime branching.
///
/// ## Usage in build commands
///
/// ```sh
/// # Local development — default, no flag needed
/// flutter run
///
/// # Staging (CI pre-production build)
/// flutter build apk --dart-define=APP_FLAVOR=staging
///
/// # Production release
/// flutter build appbundle --dart-define=APP_FLAVOR=prod
/// ```
///
/// ## Usage in code
///
/// ```dart
/// final flavor = ref.watch(appFlavorProvider);
///
/// if (flavor == AppFlavor.staging) {
///   // Show a "STAGING" debug banner.
/// }
/// ```
///
/// Verbose-logging and crash-reporting gating by flavor is NOT done
/// ad-hoc at call sites like the snippet above — see
/// `core/logging/log_level_policy.dart`, the single place that reads
/// [currentFlavor] to decide Talker verbosity and `TalkerDioLoggerSettings`
/// header redaction. (Audited 25 Jun 2026: this doc comment used to show
/// `if (flavor != AppFlavor.prod) talker.verbose(...)` as an illustrative
/// example that was never actually wired into `talker_provider.dart` —
/// removed here now that it is.)
enum AppFlavor {
  /// Local developer builds. Verbose logging, internal tooling enabled.
  dev,

  /// Pre-production environment. Mirrors prod infra, not shown to end users.
  staging,

  /// Live production. Analytics on, debug overlays off, crash reporting on.
  prod,
}

/// Reads the current [AppFlavor] from the compile-time dart-define.
///
/// [String.fromEnvironment] is evaluated at compile time by the Dart
/// compiler — it is NOT a runtime environment variable lookup. The
/// `--dart-define` flag at build time is the only way to change the value.
///
/// Defaults to [AppFlavor.dev] so local `flutter run` without any flags
/// always behaves as expected.
///
/// Public (was `_currentFlavor`, audited 25 Jun 2026) — `log_level_policy.dart`
/// needs this exact same compile-time signal at a point where no `Ref` is
/// available yet (the `talker` global var in `talker_provider.dart` is
/// constructed before `ProviderScope` mounts — see that file's doc comment).
/// Re-deriving the flavor from a second `String.fromEnvironment` call in a
/// different file would risk the two copies drifting if the dart-define
/// values ever change — keeping one function as the single source avoids
/// that entirely. [appFlavorProvider] below now simply wraps this.
AppFlavor currentFlavor() {
  const raw = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
  return switch (raw) {
    'prod' => AppFlavor.prod,
    'staging' => AppFlavor.staging,
    _ => AppFlavor.dev,
  };
}

/// Provides the current [AppFlavor] throughout the app.
///
/// [keepAlive: true] — the flavor is baked in at compile time and is
/// constant for the entire app lifetime. There is no reason to ever
/// dispose and recreate this provider.
///
/// Consume via `ref.watch(appFlavorProvider)` in notifiers or widgets.
/// Use `ref.read(appFlavorProvider)` for one-off checks (e.g. in
/// logging setup or DI configuration at startup).
@Riverpod(keepAlive: true)
AppFlavor appFlavor(Ref ref) => currentFlavor();
