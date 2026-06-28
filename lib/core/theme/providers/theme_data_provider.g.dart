// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the light [ThemeData] built from design tokens.
///
/// Keeping this as a provider instead of a direct static call allows
/// future runtime overrides such as whitelabel branding, dynamic color,
/// or theme experimentation without changing consumer code.

@ProviderFor(lightTheme)
final lightThemeProvider = LightThemeProvider._();

/// Provides the light [ThemeData] built from design tokens.
///
/// Keeping this as a provider instead of a direct static call allows
/// future runtime overrides such as whitelabel branding, dynamic color,
/// or theme experimentation without changing consumer code.

final class LightThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provides the light [ThemeData] built from design tokens.
  ///
  /// Keeping this as a provider instead of a direct static call allows
  /// future runtime overrides such as whitelabel branding, dynamic color,
  /// or theme experimentation without changing consumer code.
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

/// Light theme scaled for medium (tablet) breakpoint — 1.1× font factor.

@ProviderFor(lightThemeMedium)
final lightThemeMediumProvider = LightThemeMediumProvider._();

/// Light theme scaled for medium (tablet) breakpoint — 1.1× font factor.

final class LightThemeMediumProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Light theme scaled for medium (tablet) breakpoint — 1.1× font factor.
  LightThemeMediumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightThemeMediumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightThemeMediumHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return lightThemeMedium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$lightThemeMediumHash() => r'd1c11533805bf3ccfbd2bacff9a3fd7d3f838050';

/// Dark theme scaled for medium (tablet) breakpoint — 1.1× font factor.

@ProviderFor(darkThemeMedium)
final darkThemeMediumProvider = DarkThemeMediumProvider._();

/// Dark theme scaled for medium (tablet) breakpoint — 1.1× font factor.

final class DarkThemeMediumProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Dark theme scaled for medium (tablet) breakpoint — 1.1× font factor.
  DarkThemeMediumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkThemeMediumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkThemeMediumHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return darkThemeMedium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$darkThemeMediumHash() => r'b046cd1d07308607187be46fe24e67a8f0abf1cb';

/// Light theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.

@ProviderFor(lightThemeExpanded)
final lightThemeExpandedProvider = LightThemeExpandedProvider._();

/// Light theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.

final class LightThemeExpandedProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Light theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.
  LightThemeExpandedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightThemeExpandedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightThemeExpandedHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return lightThemeExpanded(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$lightThemeExpandedHash() =>
    r'10131707649172217a49b5ed7433578a4552cc0b';

/// Dark theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.

@ProviderFor(darkThemeExpanded)
final darkThemeExpandedProvider = DarkThemeExpandedProvider._();

/// Dark theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.

final class DarkThemeExpandedProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Dark theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.
  DarkThemeExpandedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'darkThemeExpandedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$darkThemeExpandedHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return darkThemeExpanded(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$darkThemeExpandedHash() => r'8ed3ffc888d7bd2cb026ff11615231e31b4c9da2';
