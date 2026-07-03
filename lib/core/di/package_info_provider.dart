// dart run build_runner build --delete-conflicting-outputs
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';

part 'package_info_provider.g.dart';

/// Provides the app's [PackageInfo] resolved from the platform at runtime.
///
/// Kept alive for the app lifecycle — [PackageInfo] is immutable after
/// launch and re-reading from the platform channel on every watch would
/// be wasteful.
///
/// `package_info_plus`'s Package Evaluation (purpose, alternatives
/// considered, maintenance/risk assessment) is recorded in
/// `docs/PACKAGE_DECISIONS.md` — Recommendation: Required.
///
/// ## Fields exposed by [PackageInfo]
///
/// | Field          | Example         | Source                        |
/// |----------------|-----------------|-------------------------------|
/// | appName        | TokenShell      | pubspec.yaml → `name`         |
/// | packageName    | com.example.app | AndroidManifest / Info.plist  |
/// | version        | 1.2.0           | pubspec.yaml → `version`      |
/// | buildNumber    | 42              | pubspec.yaml → `+42`          |
///
/// NOTE: [PackageInfo] reflects the *app* version, not the Flutter SDK
/// version. To display the Flutter SDK version (e.g. "3.32.0") use this
/// provider for the app version label and hardcode the SDK version in a
/// separate constant updated at upgrade time — there is no public runtime
/// API to read the Flutter SDK version in a production build.
///
/// ## Error observability (R17)
///
/// `SettingsPage` reads this via `packageInfoAsync.asData?.value.version ??
/// AppStrings.settingsAboutVersionFallback` — a safe UI fallback for the
/// `AsyncError` case, but on its own that silently swallows the failure:
/// nothing was ever logged, so a real platform-channel failure here was
/// invisible in Sentry/Talker. The try/catch below logs it — mirroring the
/// same `talker.handle()` pattern `app.dart` already uses for its
/// light/dark `ThemeData` fallback — before rethrowing, so `AsyncError` and
/// the existing UI fallback behavior are unchanged; only the observability
/// gap is closed.
@Riverpod(keepAlive: true)
Future<PackageInfo> packageInfo(Ref ref) async {
  try {
    return await PackageInfo.fromPlatform();
  } on Object catch (e, stackTrace) {
    ref
        .read(talkerProvider)
        .handle(
          e,
          stackTrace,
          'Failed to resolve PackageInfo.fromPlatform() — Settings will '
          'fall back to AppStrings.settingsAboutVersionFallback',
        );
    rethrow;
  }
}
