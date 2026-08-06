import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Static helpers and pre-built token snapshots used by [AppTheme].
///
/// [lightStatus] and [darkStatus] are [const] — allocated once at startup.
/// [colorSchemeFrom] and [textThemeFrom] are factory methods called once
/// per theme build and cached inside [ThemeData].
abstract final class ThemeConstants {
  // ── Pre-resolved status snapshots ────────────────────────────────────────────
  //
  // Status colors (success/warning/info/error) have no native M3 ColorScheme
  // role, so they're the only piece still carried through a dedicated
  // snapshot + [ThemeExtension] — see [AppStatusColors] and
  // [AppThemeExtension]. Every other role is read straight from
  // [colorSchemeFrom] below; there is no longer an intermediate token
  // wrapper duplicating [ColorScheme] under different field names.

  static const AppStatusColors lightStatus = AppStatusColors(
    success: ColorTokens.lightSuccess,
    successForeground: ColorTokens.lightSuccessForeground,
    warning: ColorTokens.lightWarning,
    warningForeground: ColorTokens.lightWarningForeground,
    info: ColorTokens.lightInfo,
    infoForeground: ColorTokens.lightInfoForeground,
    error: ColorTokens.lightStatusError,
    errorForeground: ColorTokens.lightStatusErrorForeground,
  );

  static const AppStatusColors darkStatus = AppStatusColors(
    success: ColorTokens.darkSuccess,
    successForeground: ColorTokens.darkSuccessForeground,
    warning: ColorTokens.darkWarning,
    warningForeground: ColorTokens.darkWarningForeground,
    info: ColorTokens.darkInfo,
    infoForeground: ColorTokens.darkInfoForeground,
    error: ColorTokens.darkStatusError,
    errorForeground: ColorTokens.darkStatusErrorForeground,
  );

  // ── ColorScheme factory ───────────────────────────────────────────────────────

  /// Builds a Material 3 [ColorScheme] mapped 1:1 from the M3 role tokens in
  /// [ColorTokens]. Every role holds a value with a genuine M3 tonal
  /// relationship, computed in the token file with documented contrast math
  /// — this factory is a thin assembler, not a place that invents colors.
  ///
  /// Two roles are worth calling out because they carry a deliberate
  /// app-level decision rather than an M3-prescribed default:
  ///   * `secondaryContainer` is used as this app's general-purpose
  ///     "quiet surface" tone (chips, muted fills) rather than reserved
  ///     purely for M3's literal secondary-action semantics.
  ///   * `secondaryContainer` / `onSecondaryContainer` are also the
  ///     selected-state colors for [NavigationBar], [NavigationRail], and
  ///     selected [ListTile]s (see `navigation_theme_builder.dart` and
  ///     `surface_theme_builder.dart`) — the M3-canonical choice, in place
  ///     of the app's earlier primary-based "accent" bridge.
  static ColorScheme colorSchemeFrom(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ColorScheme(
      brightness: brightness,

      // ── Primary ─────────────────────────────────────────────────────────────
      primary: isLight ? ColorTokens.lightPrimary : ColorTokens.darkPrimary,
      onPrimary: isLight
          ? ColorTokens.lightOnPrimary
          : ColorTokens.darkOnPrimary,
      primaryContainer: isLight
          ? ColorTokens.lightPrimaryContainer
          : ColorTokens.darkPrimaryContainer,
      onPrimaryContainer: isLight
          ? ColorTokens.lightOnPrimaryContainer
          : ColorTokens.darkOnPrimaryContainer,
      // Fixed roles are brightness-invariant by M3 contract — same ramp values
      // regardless of which brightness this scheme resolves to.
      primaryFixed: ColorTokens.primaryFixed,
      primaryFixedDim: ColorTokens.primaryFixedDim,
      onPrimaryFixed: ColorTokens.onPrimaryFixed,
      onPrimaryFixedVariant: ColorTokens.onPrimaryFixedVariant,

      // ── Secondary ───────────────────────────────────────────────────────────
      secondary: isLight
          ? ColorTokens.lightSecondary
          : ColorTokens.darkSecondary,
      onSecondary: isLight
          ? ColorTokens.lightOnSecondary
          : ColorTokens.darkOnSecondary,
      secondaryContainer: isLight
          ? ColorTokens.lightSecondaryContainer
          : ColorTokens.darkSecondaryContainer,
      onSecondaryContainer: isLight
          ? ColorTokens.lightOnSecondaryContainer
          : ColorTokens.darkOnSecondaryContainer,
      secondaryFixed: ColorTokens.secondaryFixed,
      secondaryFixedDim: ColorTokens.secondaryFixedDim,
      onSecondaryFixed: ColorTokens.onSecondaryFixed,
      onSecondaryFixedVariant: ColorTokens.onSecondaryFixedVariant,

      // ── Tertiary ────────────────────────────────────────────────────────────
      // Monochrome scheme: tertiary is an offset neutral ramp (documented in
      // ColorTokens) so widgets reading tertiary stay distinguishable.
      tertiary: isLight ? ColorTokens.lightTertiary : ColorTokens.darkTertiary,
      onTertiary: isLight
          ? ColorTokens.lightOnTertiary
          : ColorTokens.darkOnTertiary,
      tertiaryContainer: isLight
          ? ColorTokens.lightTertiaryContainer
          : ColorTokens.darkTertiaryContainer,
      onTertiaryContainer: isLight
          ? ColorTokens.lightOnTertiaryContainer
          : ColorTokens.darkOnTertiaryContainer,
      tertiaryFixed: ColorTokens.tertiaryFixed,
      tertiaryFixedDim: ColorTokens.tertiaryFixedDim,
      onTertiaryFixed: ColorTokens.onTertiaryFixed,
      onTertiaryFixedVariant: ColorTokens.onTertiaryFixedVariant,

      // ── Error — M3 baseline palette, explicit ──────────────────────────────
      error: isLight ? ColorTokens.lightError : ColorTokens.darkError,
      onError: isLight ? ColorTokens.lightOnError : ColorTokens.darkOnError,
      errorContainer: isLight
          ? ColorTokens.lightErrorContainer
          : ColorTokens.darkErrorContainer,
      onErrorContainer: isLight
          ? ColorTokens.lightOnErrorContainer
          : ColorTokens.darkOnErrorContainer,

      // ── Surface hierarchy — the five M3 container tiers, explicit ───────────
      surface: isLight ? ColorTokens.lightSurface : ColorTokens.darkSurface,
      onSurface: isLight
          ? ColorTokens.lightOnSurface
          : ColorTokens.darkOnSurface,
      onSurfaceVariant: isLight
          ? ColorTokens.lightOnSurfaceVariant
          : ColorTokens.darkOnSurfaceVariant,
      surfaceContainerLowest: isLight
          ? ColorTokens.lightSurfaceContainerLowest
          : ColorTokens.darkSurfaceContainerLowest,
      surfaceContainerLow: isLight
          ? ColorTokens.lightSurfaceContainerLow
          : ColorTokens.darkSurfaceContainerLow,
      surfaceContainer: isLight
          ? ColorTokens.lightSurfaceContainer
          : ColorTokens.darkSurfaceContainer,
      surfaceContainerHigh: isLight
          ? ColorTokens.lightSurfaceContainerHigh
          : ColorTokens.darkSurfaceContainerHigh,
      surfaceContainerHighest: isLight
          ? ColorTokens.lightSurfaceContainerHighest
          : ColorTokens.darkSurfaceContainerHighest,
      surfaceDim: isLight
          ? ColorTokens.lightSurfaceDim
          : ColorTokens.darkSurfaceDim,
      surfaceBright: isLight
          ? ColorTokens.lightSurfaceBright
          : ColorTokens.darkSurfaceBright,

      // Tonal elevation: M3 components tint elevated surfaces with
      // `surfaceTint` (Flutter defaults to `primary`, which is what this
      // app uses too — no override).
      surfaceTint: isLight ? ColorTokens.lightPrimary : ColorTokens.darkPrimary,

      // ── Inverse surfaces ────────────────────────────────────────────────────
      inverseSurface: isLight
          ? ColorTokens.lightInverseSurface
          : ColorTokens.darkInverseSurface,
      onInverseSurface: isLight
          ? ColorTokens.lightOnInverseSurface
          : ColorTokens.darkOnInverseSurface,
      inversePrimary: isLight
          ? ColorTokens.lightInversePrimary
          : ColorTokens.darkInversePrimary,

      // ── Borders — M3 role semantics ─────────────────────────────────────────
      // outline        → component borders (full weight, non-text 3:1 contract)
      // outlineVariant → decorative dividers / separators (solid tone, no alpha)
      outline: isLight ? ColorTokens.lightOutline : ColorTokens.darkOutline,
      outlineVariant: isLight
          ? ColorTokens.lightOutlineVariant
          : ColorTokens.darkOutlineVariant,

      // Scrim / shadow — opaque black per M3.
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
    );
  }

  // ── TextTheme factory ─────────────────────────────────────────────────────────

  /// Builds a [TextTheme] on the M3 baseline type scale (m3.material.io/styles/typography/type-scale-tokens).
  ///
  /// Font family stays Geist ([TypographyTokens.fontFamily]) — the M3 spec
  /// does not mandate a typeface. Size, weight and letter-spacing values are
  /// snapped 1:1 to the M3 type-scale table and are written as literals with
  /// inline cross-references. [TypographyTokens]'s own `size*`/`tracking*`
  /// constants are a separate, smaller set used for component-level type
  /// tweaks (badges, overline-style labels) that intentionally sit outside
  /// the M3 role scale — see the doc comment on [TypographyTokens] for the
  /// distinction.
  ///
  /// Line height is left at `null` so Geist's natural font metrics apply —
  /// the M3 spec's leading values (display 64/52/44 px on mobile etc.) are
  /// platform-font-metric results, not hard multipliers the component layers
  /// enforce, and Flutter's own `TextTheme` default does the same.
  ///
  /// The [foreground] color is applied to all roles; widget-level overrides
  /// (e.g. muted hint text) are applied inside [AppTheme]'s widget theme configs.
  static TextTheme textThemeFrom(Color foreground) {
    const font = TypographyTokens.fontFamily;
    const fallback = TypographyTokens.fontFamilyFallback;
    return TextTheme(
      // Display — M3: 57/45/36, regular w400
      displayLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 57, // M3 displayLarge
        fontWeight: FontWeight.w400, // M3 displayLarge weight
        letterSpacing: -0.25, // M3 displayLarge tracking
        color: foreground,
      ),
      displayMedium: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 45, // M3 displayMedium
        fontWeight: FontWeight.w400,
        letterSpacing: 0, // M3 displayMedium tracking
        color: foreground,
      ),
      displaySmall: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 36, // M3 displaySmall
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: foreground,
      ),

      // Headline — M3: 32/28/24, regular w400
      headlineLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 32, // M3 headlineLarge
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 28, // M3 headlineMedium
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: foreground,
      ),
      headlineSmall: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 24, // M3 headlineSmall
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: foreground,
      ),

      // Title — M3: 22 regular w400 / 16 medium w500 / 14 medium w500
      titleLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 22, // M3 titleLarge
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: foreground,
      ),
      titleMedium: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 16, // M3 titleMedium
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15, // M3 titleMedium tracking
        color: foreground,
      ),
      titleSmall: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 14, // M3 titleSmall
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1, // M3 titleSmall tracking
        color: foreground,
      ),

      // Label — M3: 14/12/11, medium w500
      labelLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 14, // M3 labelLarge
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: foreground,
      ),
      labelMedium: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 12, // M3 labelMedium
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: foreground,
      ),
      labelSmall: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 11, // M3 labelSmall
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: foreground,
      ),

      // Body — M3: 16/14/12, regular w400
      bodyLarge: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 16, // M3 bodyLarge
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: foreground,
      ),
      bodyMedium: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 14, // M3 bodyMedium
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: foreground,
      ),
      bodySmall: TextStyle(
        fontFamily: font,
        fontFamilyFallback: fallback,
        fontSize: 12, // M3 bodySmall
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: foreground,
      ),
    );
  }
}
