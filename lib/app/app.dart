import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';
import 'package:tokenshell_riverpod/core/routing/app_router.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/notifiers/theme_mode_notifier.dart';
import 'package:tokenshell_riverpod/core/theme/providers/theme_data_provider.dart';
import 'package:tokenshell_riverpod/core/theme/theme_constants.dart';
import 'package:tokenshell_riverpod/core/utils/responsive_helper.dart';

/// Root application widget.
///
// ignore: comment_references
/// Consumes [appRouterProvider] and [themeModeNotifierProvider] so that
/// routing and theming are fully driven by Riverpod state.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Show a plain loading scaffold while the persisted theme loads.
    final themeAsync = ref.watch(themeModeProvider);
    final themeMode = themeAsync.when(
      data: (mode) => mode,
      loading: () => ThemeMode.system,
      error: (_, _) => ThemeMode.system,
    );

    // [lightThemeProvider] / [darkThemeProvider] are 100% const-derived
    // today, so this should never actually throw — but every other
    // failure path in this theme subsystem (ThemeModeNotifier,
    // ThemeModeRepository, the `.when()` above) already degrades to a
    // safe default instead of crashing the whole app at the root. This
    // keeps that same guarantee here instead of leaving these two
    // providers as the one unguarded link in the chain — defense in
    // depth for if either ever grows real logic (e.g. remote-config
    // theming) that *can* fail.
    //
    // IMPORTANT: both fallback ThemeData objects must register
    // AppThemeExtension — without it, every context.colors call in the
    // widget tree throws StateError ("AppThemeExtension not found in
    // ThemeData"), which defeats the entire purpose of the fallback.
    // ThemeConstants.lightColors / darkColors are const, so registering
    // them here costs nothing at runtime.
    ThemeData lightTheme;
    ThemeData darkTheme;
    try {
      lightTheme = ref.watch(lightThemeProvider);
      darkTheme = ref.watch(darkThemeProvider);
    } on Object catch (e, stackTrace) {
      ref
          .read(talkerProvider)
          .handle(
            e,
            stackTrace,
            'Failed to build light/dark ThemeData — falling back to '
            'Material defaults with AppThemeExtension registered',
          );
      lightTheme = ThemeData.light(useMaterial3: true).copyWith(
        extensions: [const AppThemeExtension(colors: ThemeConstants.lightColors)],
      );
      darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
        extensions: [const AppThemeExtension(colors: ThemeConstants.darkColors)],
      );
    }

    return MaterialApp.router(
      title: 'TokenShell Riverpod',
      debugShowCheckedModeBanner: false,

      // Compact (the most common class) uses the base ThemeData directly —
      // no font scaling needed, no extra Theme widget in the tree.
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      // Router
      routerConfig: router,

      // ── Responsive text scaling ───────────────────────────────────────────────
      //
      // On medium / expanded screens, wraps the router child in a [Theme]
      // widget backed by a pre-computed, provider-cached [ThemeData] variant.
      //
      // Previously this called ThemeData.copyWith() + TextTheme.apply() inline
      // here, allocating new objects on every builder invocation — including
      // every window-resize event on web/desktop. Each new ThemeData reference
      // triggered Theme.updateShouldNotify → cascading subtree rebuild.
      //
      // With pre-computed providers (keepAlive) the ThemeData reference is
      // stable: Theme.updateShouldNotify returns false on resize, and no
      // cascade occurs until the user explicitly changes the theme mode.
      //
      // compact (< 600 px): factor 1.0 — no-op, child returned directly.
      // medium  (600-839 px): factor 1.1 — handled by lightThemeMediumProvider.
      // expanded (≥ 840 px): factor 1.2 — handled by lightThemeExpandedProvider.
      builder: (context, child) {
        final sizeClass = ResponsiveHelper.of(context);
        if (sizeClass == ScreenSizeClass.compact) return child!;
        return _ScaledThemeOverlay(sizeClass: sizeClass, child: child!);
      },
    );
  }
}

// ── Scaled theme overlay ──────────────────────────────────────────────────────

/// Injects the appropriate pre-computed [ThemeData] for non-compact screens.
///
/// Implemented as a [ConsumerWidget] so it can read the scaled theme providers
/// without requiring a [ProviderScope] lookup from the builder callback.
/// The [ThemeData] instances watched here are [keepAlive] providers — they are
/// allocated once and the reference never changes, so [Theme.updateShouldNotify]
/// always returns `false` unless the user changes the theme mode.
///
/// ## Why [AnimatedTheme], not [Theme]
///
/// `MaterialApp` wraps its own child in an `AnimatedTheme` internally, so
/// toggling light/dark mode on a *compact* screen cross-fades smoothly.
/// This widget used to insert a plain, non-animated [Theme] on top of
/// that — which instantly overrides whatever the surrounding
/// `AnimatedTheme` was mid-transition to, so medium/expanded screens got
/// an abrupt, un-animated switch while compact screens got a smooth one.
/// Using [AnimatedTheme] here too restores a consistent feel across every
/// breakpoint. [context.durations] is used instead of a hardcoded
/// [Duration] so this transition is also zeroed under OS-level
/// reduce-motion, same as every other animation in the app.
class _ScaledThemeOverlay extends ConsumerWidget {
  const _ScaledThemeOverlay({
    required this.sizeClass,
    required this.child,
  });

  final ScreenSizeClass sizeClass;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;

    final ThemeData scaled;
    if (brightness == Brightness.dark) {
      scaled = sizeClass == ScreenSizeClass.medium
          ? ref.watch(darkThemeMediumProvider)
          : ref.watch(darkThemeExpandedProvider);
    } else {
      scaled = sizeClass == ScreenSizeClass.medium
          ? ref.watch(lightThemeMediumProvider)
          : ref.watch(lightThemeExpandedProvider);
    }

    return AnimatedTheme(
      data: scaled,
      child: child,
    );
  }
}
