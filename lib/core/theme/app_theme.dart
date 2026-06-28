import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/builders/button_theme_builder.dart';
import 'package:tokenshell_riverpod/core/theme/builders/feedback_theme_builder.dart';
import 'package:tokenshell_riverpod/core/theme/builders/input_theme_builder.dart';
import 'package:tokenshell_riverpod/core/theme/builders/navigation_theme_builder.dart';
import 'package:tokenshell_riverpod/core/theme/builders/surface_theme_builder.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/theme_constants.dart';

/// Produces fully-configured [ThemeData] for light and dark modes.
///
/// Both factory methods are pure functions: given the same token set
/// they always return the same [ThemeData]. Zero values are hardcoded
/// here — every dimension, color, opacity, and duration is sourced from
/// a token file in the design_system barrel.
///
/// The ~40 individual widget sub-themes used to all live inline in
/// [_build] (800+ lines in one static method). They're now composed from
/// five `*ThemeBuilder` classes in `core/theme/builders/`, grouped by
/// widget family (buttons, inputs, surfaces, navigation, feedback) —
/// see `builders/button_theme_builder.dart` for the full rationale.
/// [_build] itself is now just the glue: colorScheme/textTheme
/// composition, a few one-line scalars that don't belong to any single
/// widget family, and the call into each builder. No resolved value
/// changed as part of that split.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(),
///   darkTheme: AppTheme.dark(),
/// );
/// ```
abstract final class AppTheme {
  /// Returns a complete light-mode [ThemeData].
  static ThemeData light() => _build(
    colors: ThemeConstants.lightColors,
    brightness: Brightness.light,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  /// Returns a complete dark-mode [ThemeData].
  static ThemeData dark() => _build(
    colors: ThemeConstants.darkColors,
    brightness: Brightness.dark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ── Internal builder ──────────────────────────────────────────────────────────

  static ThemeData _build({
    required AppThemeColors colors,
    required Brightness brightness,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final colorScheme = ThemeConstants.colorSchemeFrom(colors, brightness);
    final textTheme = ThemeConstants.textThemeFrom(colors.foreground);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,

      // Register the shadcn/ui extension — required for AppThemeExtension.of(ctx)
      extensions: [AppThemeExtension(colors: colors)],

      // ── Scaffold ────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: colors.background,

      // ── Navigation chrome ──────────────────────────────────────────────────
      appBarTheme: NavigationThemeBuilder.appBar(
        colors,
        textTheme,
        systemOverlayStyle,
      ),
      navigationBarTheme: NavigationThemeBuilder.navigationBar(
        colors,
        textTheme,
      ),
      navigationRailTheme: NavigationThemeBuilder.navigationRail(
        colors,
        textTheme,
      ),
      tabBarTheme: NavigationThemeBuilder.tabBar(colors, textTheme),
      drawerTheme: NavigationThemeBuilder.drawer(colors),

      // ── Surfaces / containers ────────────────────────────────────────────────
      cardTheme: SurfaceThemeBuilder.card(colors),
      dividerTheme: SurfaceThemeBuilder.divider(colors),
      dividerColor: colors.border,
      dialogTheme: SurfaceThemeBuilder.dialog(colors, textTheme),
      listTileTheme: SurfaceThemeBuilder.listTile(colors, textTheme),
      popupMenuTheme: SurfaceThemeBuilder.popupMenu(colors, textTheme),
      bottomSheetTheme: SurfaceThemeBuilder.bottomSheet(colors),
      tooltipTheme: SurfaceThemeBuilder.tooltip(colors, textTheme),

      // ── Form inputs ───────────────────────────────────────────────────────────
      inputDecorationTheme: InputThemeBuilder.inputDecoration(
        colors,
        textTheme,
      ),
      dropdownMenuTheme: InputThemeBuilder.dropdownMenu(colors, textTheme),

      // ── Buttons ───────────────────────────────────────────────────────────────
      elevatedButtonTheme: ButtonThemeBuilder.elevatedButton(colors, textTheme),
      outlinedButtonTheme: ButtonThemeBuilder.outlinedButton(colors, textTheme),
      textButtonTheme: ButtonThemeBuilder.textButton(colors, textTheme),
      segmentedButtonTheme: ButtonThemeBuilder.segmentedButton(
        colors,
        textTheme,
      ),
      floatingActionButtonTheme: ButtonThemeBuilder.floatingActionButton(
        colors,
      ),

      // ── Feedback / small interactive controls ────────────────────────────────
      chipTheme: FeedbackThemeBuilder.chip(colors, textTheme),
      switchTheme: FeedbackThemeBuilder.switchTheme(colors),
      checkboxTheme: FeedbackThemeBuilder.checkbox(colors),
      radioTheme: FeedbackThemeBuilder.radio(colors),
      snackBarTheme: FeedbackThemeBuilder.snackBar(colors, textTheme),
      progressIndicatorTheme: FeedbackThemeBuilder.progressIndicator(colors),
      sliderTheme: FeedbackThemeBuilder.slider(colors, textTheme),
      badgeTheme: FeedbackThemeBuilder.badge(colors, textTheme),
      expansionTileTheme: FeedbackThemeBuilder.expansionTile(colors),
      scrollbarTheme: FeedbackThemeBuilder.scrollbar(colors),
      menuButtonTheme: FeedbackThemeBuilder.menuButton(colors, textTheme),

      // ── Icons ────────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: colors.foreground,
        size: IconSizeTokens.md,
      ),
      primaryIconTheme: IconThemeData(
        color: colors.primaryForeground,
        size: IconSizeTokens.md,
      ),

      // ── Splash / ink — minimal to keep shadcn feel ───────────────────────────
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: colors.accent.withValues(
        alpha: OpacityTokens.disabledSurface,
      ),
      // Use [OpacityTokens.focusOverlay] rather than [OpacityTokens.pressed] —
      // both are 0.12 today, but they are separate semantics. Keeping them as
      // distinct constants lets the design system tune pressed and focus
      // overlays independently as the product matures without an accidental
      // cross-coupling (see OpacityTokens.focusOverlay doc comment).
      focusColor: colors.ring.withValues(alpha: OpacityTokens.focusOverlay),
    );
  }
}
