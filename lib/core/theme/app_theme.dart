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
/// Both factory methods are pure functions: given the same brightness they
/// always return the same [ThemeData]. Zero values are hardcoded here —
/// every dimension, color, opacity, and duration is sourced from a token
/// file in the design_system barrel.
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
    status: ThemeConstants.lightStatus,
    brightness: Brightness.light,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  /// Returns a complete dark-mode [ThemeData].
  static ThemeData dark() => _build(
    status: ThemeConstants.darkStatus,
    brightness: Brightness.dark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ── Internal builder ──────────────────────────────────────────────────────────

  static ThemeData _build({
    required AppStatusColors status,
    required Brightness brightness,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final colors = ThemeConstants.colorSchemeFrom(brightness);
    final textTheme = ThemeConstants.textThemeFrom(colors.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      textTheme: textTheme,
      // Explicitly mirror `textTheme` here instead of leaving this unset.
      // Left unset, `ThemeData` falls back to its own legacy
      // `Typography`-derived default — a `TextTheme` that is only fully
      // resolved (every role's `fontSize` non-null) AFTER it passes through
      // `MaterialApp`'s widget-tree localization step. Reading it directly
      // off a raw `ThemeData` built outside the widget tree (exactly what
      // `theme_data_provider.dart`'s scaled `*Medium`/`*Expanded` variants
      // do via `.apply(fontSizeFactor: ...)`) can hit a role whose
      // `fontSize` is still null at that point, which trips the
      // `fontSize != null || (fontSizeFactor == 1.0 && ...)` assertion in
      // `TextStyle.apply`. Pointing `primaryTextTheme` at our own
      // `textTheme` — which has every role's `fontSize` hardcoded from
      // `TypographyTokens` — sidesteps that framework default entirely, so
      // `.apply()` on it is always safe regardless of widget-tree state.
      primaryTextTheme: textTheme,

      // Register the status-colors extension — required for
      // AppThemeExtension.of(ctx). Every other color role is already on
      // `colorScheme` above and needs no extension.
      extensions: [AppThemeExtension(status: status)],

      // ── Scaffold ────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: colors.surface,

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
        color: colors.onSurface,
        size: IconSizeTokens.md,
      ),
      primaryIconTheme: IconThemeData(
        color: colors.onPrimary,
        size: IconSizeTokens.md,
      ),

      // ── Splash / ink / state layers ──────────────────────────────────────────
      // No overrides at this level: components get the M3 interaction
      // defaults —
      //   • ripple via the platform InkSparkle/InkRipple splashFactory,
      //   • state layers per m3.material.io/foundations/interaction/states
      //     (hover onSurface@8%, focus @12%, pressed @12%, dragged @16%).
      // The ripple is not a state layer itself — it's the pressed feedback the
      // M3 spec pairs with those overlays. Tonal elevation is provided
      // through ColorScheme.surfaceTint = primary (see theme_constants.dart).
    );
  }
}
