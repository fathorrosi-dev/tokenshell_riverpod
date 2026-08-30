// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
/// ## Error observability
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

@ProviderFor(packageInfo)
final packageInfoProvider = PackageInfoProvider._();

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
/// ## Error observability
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

final class PackageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
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
  /// ## Error observability
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
  PackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return packageInfo(ref);
  }
}

String _$packageInfoHash() => r'a25db51ac2378bec57dca904714bf56c58337b90';
