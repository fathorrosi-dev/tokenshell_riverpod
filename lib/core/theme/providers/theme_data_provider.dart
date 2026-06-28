import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/theme/app_theme.dart';

part 'theme_data_provider.g.dart';

/// Provides the light [ThemeData] built from design tokens.
///
/// Keeping this as a provider instead of a direct static call allows
/// future runtime overrides such as whitelabel branding, dynamic color,
/// or theme experimentation without changing consumer code.
@Riverpod(keepAlive: true)
ThemeData lightTheme(Ref ref) => AppTheme.light();

/// Provides the dark [ThemeData] built from design tokens.
@Riverpod(keepAlive: true)
ThemeData darkTheme(Ref ref) => AppTheme.dark();

// ── Responsive scaled variants ───────────────────────────────────────────────
//
// Pre-computing scaled ThemeData at provider level (keepAlive) means the
// TextTheme.apply() allocation happens ONCE, not on every MaterialApp.builder
// call. On web/desktop, window-resize events trigger MediaQuery changes which
// call the builder frequently — previously this called ThemeData.copyWith()
// on every resize, causing cascading theme rebuilds across the subtree.
//
// With pre-computed variants: App.builder selects the appropriate cached
// ThemeData via _ScaledThemeOverlay → Theme(data: prebuiltTheme).
// Theme.updateShouldNotify returns false because the reference is stable,
// so no cascade occurs until the user explicitly changes the theme mode.
//
// medium  (600–839 px): +10 % font-size factor.
// expanded (≥ 840 px): +20 % font-size factor.

/// Light theme scaled for medium (tablet) breakpoint — 1.1× font factor.
@Riverpod(keepAlive: true)
ThemeData lightThemeMedium(Ref ref) {
  final base = ref.watch(lightThemeProvider);
  return base.copyWith(
    textTheme: base.textTheme.apply(fontSizeFactor: 1.1),
    primaryTextTheme: base.primaryTextTheme.apply(fontSizeFactor: 1.1),
  );
}

/// Dark theme scaled for medium (tablet) breakpoint — 1.1× font factor.
@Riverpod(keepAlive: true)
ThemeData darkThemeMedium(Ref ref) {
  final base = ref.watch(darkThemeProvider);
  return base.copyWith(
    textTheme: base.textTheme.apply(fontSizeFactor: 1.1),
    primaryTextTheme: base.primaryTextTheme.apply(fontSizeFactor: 1.1),
  );
}

/// Light theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.
@Riverpod(keepAlive: true)
ThemeData lightThemeExpanded(Ref ref) {
  final base = ref.watch(lightThemeProvider);
  return base.copyWith(
    textTheme: base.textTheme.apply(fontSizeFactor: 1.2),
    primaryTextTheme: base.primaryTextTheme.apply(fontSizeFactor: 1.2),
  );
}

/// Dark theme scaled for expanded (desktop/large tablet) breakpoint — 1.2× font factor.
@Riverpod(keepAlive: true)
ThemeData darkThemeExpanded(Ref ref) {
  final base = ref.watch(darkThemeProvider);
  return base.copyWith(
    textTheme: base.textTheme.apply(fontSizeFactor: 1.2),
    primaryTextTheme: base.primaryTextTheme.apply(fontSizeFactor: 1.2),
  );
}
