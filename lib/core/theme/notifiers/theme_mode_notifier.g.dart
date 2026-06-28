// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via
/// [IThemeModeRepository].
///
/// State lifecycle:
///   - loading → while dependencies are initialising.
///   - data    → the resolved theme mode.
///   - error   → if repository construction fails.
///
/// Read failures are intentionally degraded to [ThemeMode.system]
/// so theme persistence issues never block application startup.
///
/// This Notifier is the conversion boundary between the pure-Dart
/// `AppThemeMode` (Domain/Data) and Flutter's [ThemeMode] (Presentation) —
/// the public API here stays [ThemeMode] so existing widget call sites
/// don't change; only the repository call underneath converts.

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via
/// [IThemeModeRepository].
///
/// State lifecycle:
///   - loading → while dependencies are initialising.
///   - data    → the resolved theme mode.
///   - error   → if repository construction fails.
///
/// Read failures are intentionally degraded to [ThemeMode.system]
/// so theme persistence issues never block application startup.
///
/// This Notifier is the conversion boundary between the pure-Dart
/// `AppThemeMode` (Domain/Data) and Flutter's [ThemeMode] (Presentation) —
/// the public API here stays [ThemeMode] so existing widget call sites
/// don't change; only the repository call underneath converts.
final class ThemeModeNotifierProvider
    extends $AsyncNotifierProvider<ThemeModeNotifier, ThemeMode> {
  /// Async notifier that loads the persisted [ThemeMode] on first build,
  /// exposes it to the widget tree, and persists changes via
  /// [IThemeModeRepository].
  ///
  /// State lifecycle:
  ///   - loading → while dependencies are initialising.
  ///   - data    → the resolved theme mode.
  ///   - error   → if repository construction fails.
  ///
  /// Read failures are intentionally degraded to [ThemeMode.system]
  /// so theme persistence issues never block application startup.
  ///
  /// This Notifier is the conversion boundary between the pure-Dart
  /// `AppThemeMode` (Domain/Data) and Flutter's [ThemeMode] (Presentation) —
  /// the public API here stays [ThemeMode] so existing widget call sites
  /// don't change; only the repository call underneath converts.
  ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();
}

String _$themeModeNotifierHash() => r'87401239f27d789c146bfbfc7bae6ff251170460';

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via
/// [IThemeModeRepository].
///
/// State lifecycle:
///   - loading → while dependencies are initialising.
///   - data    → the resolved theme mode.
///   - error   → if repository construction fails.
///
/// Read failures are intentionally degraded to [ThemeMode.system]
/// so theme persistence issues never block application startup.
///
/// This Notifier is the conversion boundary between the pure-Dart
/// `AppThemeMode` (Domain/Data) and Flutter's [ThemeMode] (Presentation) —
/// the public API here stays [ThemeMode] so existing widget call sites
/// don't change; only the repository call underneath converts.

abstract class _$ThemeModeNotifier extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
