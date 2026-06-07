// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides an already-initialised [SharedPreferences] instance.
///
/// Must be overridden in tests with a mock implementation.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides an already-initialised [SharedPreferences] instance.
///
/// Must be overridden in tests with a mock implementation.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provides an already-initialised [SharedPreferences] instance.
  ///
  /// Must be overridden in tests with a mock implementation.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'50d46e3f8d9f32715d0f3efabdce724e4b2593b4';

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via [ThemeModeRepository].
///
/// State lifecycle:
///   - loading → while [SharedPreferences] is being initialised.
///   - data    → the resolved [ThemeMode] (system / light / dark).
///   - error   → if prefs fails; UI falls back to [ThemeMode.system].

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via [ThemeModeRepository].
///
/// State lifecycle:
///   - loading → while [SharedPreferences] is being initialised.
///   - data    → the resolved [ThemeMode] (system / light / dark).
///   - error   → if prefs fails; UI falls back to [ThemeMode.system].
final class ThemeModeNotifierProvider
    extends $AsyncNotifierProvider<ThemeModeNotifier, ThemeMode> {
  /// Async notifier that loads the persisted [ThemeMode] on first build,
  /// exposes it to the widget tree, and persists changes via [ThemeModeRepository].
  ///
  /// State lifecycle:
  ///   - loading → while [SharedPreferences] is being initialised.
  ///   - data    → the resolved [ThemeMode] (system / light / dark).
  ///   - error   → if prefs fails; UI falls back to [ThemeMode.system].
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

String _$themeModeNotifierHash() => r'd4452fba1a7babb5a74fdb31f69df1b8d46be7c7';

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via [ThemeModeRepository].
///
/// State lifecycle:
///   - loading → while [SharedPreferences] is being initialised.
///   - data    → the resolved [ThemeMode] (system / light / dark).
///   - error   → if prefs fails; UI falls back to [ThemeMode.system].

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

/// Provides the light [ThemeData] built from design tokens.

@ProviderFor(lightTheme)
final lightThemeProvider = LightThemeProvider._();

/// Provides the light [ThemeData] built from design tokens.

final class LightThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provides the light [ThemeData] built from design tokens.
  LightThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return lightTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$lightThemeHash() => r'0a9019dcc77611c8e10c8705a5d6ac580cc05f33';

/// Provides the dark [ThemeData] built from design tokens.

@ProviderFor(darkTheme)
final darkThemeProvider = DarkThemeProvider._();

/// Provides the dark [ThemeData] built from design tokens.

final class DarkThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provides the dark [ThemeData] built from design tokens.
  DarkThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return darkTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$darkThemeHash() => r'6cdb19b343bfde23ab2e06a9e76d70108c330590';
