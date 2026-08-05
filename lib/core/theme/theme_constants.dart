import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Static helpers and pre-built token snapshots used by [AppTheme].
///
/// [lightColors] and [darkColors] are [const] — allocated once at startup.
/// [colorSchemeFrom] and [textThemeFrom] are factory methods called once
/// per theme build and cached inside [ThemeData].
abstract final class ThemeConstants {
  // ── Pre-resolved color snapshots ─────────────────────────────────────────────
  //
  // WAVE 0 BRIDGE: [AppThemeColors] fields still carry the old shadcn-era names
  // (muted, accent, border, input, ring, card, popover, ...) because the
  // freezed extension is frozen for this wave. Each field below is therefore
  // filled with the M3 role that now provides the semantic — see the inline
  // `// bridge:` comments. Renaming the fields on the extension is deferred
  // to a later wave alongside the builder/feature call-site updates.

  static const AppThemeColors lightColors = AppThemeColors(
    // bridge: surface (tone 98)
    background: ColorTokens.lightSurface,
    // bridge: onSurface
    foreground: ColorTokens.lightOnSurface,
    // bridge: M3 elevated cards live at surfaceContainerLow
    card: ColorTokens.lightSurfaceContainerLow,
    // bridge: onSurface
    cardForeground: ColorTokens.lightOnSurface,
    // bridge: popovers/menus render at surfaceContainerHigh in M3
    popover: ColorTokens.lightSurfaceContainerHigh,
    // bridge: onSurface
    popoverForeground: ColorTokens.lightOnSurface,
    primary: ColorTokens.lightPrimary,
    // bridge: onPrimary
    primaryForeground: ColorTokens.lightOnPrimary,
    // bridge: shadcn `secondary` was surface-like in this app; map to the M3
    // secondaryContainer family so existing consumers keep a surface value
    secondary: ColorTokens.lightSecondaryContainer,
    // bridge: onSecondaryContainer
    secondaryForeground: ColorTokens.lightOnSecondaryContainer,
    // bridge: muted ≈ highest-elevation surface tier
    muted: ColorTokens.lightSurfaceContainerHighest,
    // bridge: onSurfaceVariant (muted text role)
    mutedForeground: ColorTokens.lightOnSurfaceVariant,
    // bridge: accent ≈ primary emphasis (monochrome scheme has no hue accent)
    accent: ColorTokens.lightPrimary,
    // bridge: onPrimary
    accentForeground: ColorTokens.lightOnPrimary,
    // bridge: destructive ≈ error role
    destructive: ColorTokens.lightError,
    // bridge: onError
    destructiveForeground: ColorTokens.lightOnError,
    // bridge: decorative dividers/borders → outlineVariant
    border: ColorTokens.lightOutlineVariant,
    // bridge: input borders use full outline in M3
    input: ColorTokens.lightOutline,
    // bridge: focus indication ≈ primary (The ring concept is not available on the M3)
    ring: ColorTokens.lightPrimary,
    status: AppStatusColors(
      success: ColorTokens.lightSuccess,
      successForeground: ColorTokens.lightSuccessForeground,
      warning: ColorTokens.lightWarning,
      warningForeground: ColorTokens.lightWarningForeground,
      info: ColorTokens.lightInfo,
      infoForeground: ColorTokens.lightInfoForeground,
      error: ColorTokens.lightStatusError,
      errorForeground: ColorTokens.lightStatusErrorForeground,
    ),
  );

  static const AppThemeColors darkColors = AppThemeColors(
    // bridge: surface (tone 6)
    background: ColorTokens.darkSurface,
    // bridge: onSurface
    foreground: ColorTokens.darkOnSurface,
    // bridge: surfaceContainerLow (M3 elevated card)
    card: ColorTokens.darkSurfaceContainerLow,
    // bridge: onSurface
    cardForeground: ColorTokens.darkOnSurface,
    // bridge: surfaceContainerHigh
    popover: ColorTokens.darkSurfaceContainerHigh,
    // bridge: onSurface
    popoverForeground: ColorTokens.darkOnSurface,
    primary: ColorTokens.darkPrimary,
    // bridge: onPrimary
    primaryForeground: ColorTokens.darkOnPrimary,
    // bridge: secondaryContainer (surface-like, see light comment)
    secondary: ColorTokens.darkSecondaryContainer,
    // bridge: onSecondaryContainer
    secondaryForeground: ColorTokens.darkOnSecondaryContainer,
    // bridge: surfaceContainerHighest
    muted: ColorTokens.darkSurfaceContainerHighest,
    // bridge: onSurfaceVariant
    mutedForeground: ColorTokens.darkOnSurfaceVariant,
    // bridge: primary emphasis (monochrome — see light comment)
    accent: ColorTokens.darkPrimary,
    // bridge: onPrimary
    accentForeground: ColorTokens.darkOnPrimary,
    // bridge: error role
    destructive: ColorTokens.darkError,
    // bridge: onError
    destructiveForeground: ColorTokens.darkOnError,
    // bridge: outlineVariant
    border: ColorTokens.darkOutlineVariant,
    // bridge: outline
    input: ColorTokens.darkOutline,
    // bridge: primary
    ring: ColorTokens.darkPrimary,
    status: AppStatusColors(
      success: ColorTokens.darkSuccess,
      successForeground: ColorTokens.darkSuccessForeground,
      warning: ColorTokens.darkWarning,
      warningForeground: ColorTokens.darkWarningForeground,
      info: ColorTokens.darkInfo,
      infoForeground: ColorTokens.darkInfoForeground,
      error: ColorTokens.darkStatusError,
      errorForeground: ColorTokens.darkStatusErrorForeground,
    ),
  );

  // ── ColorScheme factory ───────────────────────────────────────────────────────

  /// Builds a Material 3 [ColorScheme] mapped 1:1 from the M3 role tokens in
  /// [ColorTokens]. No cross-design-system translation happens here anymore:
  /// every role holds a value with a genuine M3 tonal relationship, computed
  /// in the token file with documented contrast math.
  ///
  /// `c` is consumed only through the bridge snapshot (see [lightColors]);
  /// roles that exist natively in M3 read straight from the ramp constants so
  /// this factory stays a thin assembler, not a place that invents colors
  /// (all previous `Color.lerp` / `withValues(alpha:)` pseudo-roles removed).
  static ColorScheme colorSchemeFrom(AppThemeColors c, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ColorScheme(
      brightness: brightness,

      // ── Primary ─────────────────────────────────────────────────────────────
      primary: c.primary,
      onPrimary: c.primaryForeground,
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
      secondary: isLight ? ColorTokens.lightSecondary : ColorTokens.darkSecondary,
      onSecondary: isLight
          ? ColorTokens.lightOnSecondary
          : ColorTokens.darkOnSecondary,
      // Bridge fields: `c.secondary` carries the surface-like
      // secondaryContainer intentionally (see lightColors).
      secondaryContainer: c.secondary,
      onSecondaryContainer: c.secondaryForeground,
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
      error: c.destructive,
      onError: c.destructiveForeground,
      errorContainer: isLight
          ? ColorTokens.lightErrorContainer
          : ColorTokens.darkErrorContainer,
      onErrorContainer: isLight
          ? ColorTokens.lightOnErrorContainer
          : ColorTokens.darkOnErrorContainer,

      // ── Surface hierarchy — the five M3 container tiers, explicit ───────────
      surface: isLight ? ColorTokens.lightSurface : ColorTokens.darkSurface,
      onSurface: isLight ? ColorTokens.lightOnSurface : ColorTokens.darkOnSurface,
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
      surfaceDim: isLight ? ColorTokens.lightSurfaceDim : ColorTokens.darkSurfaceDim,
      surfaceBright: isLight
          ? ColorTokens.lightSurfaceBright
          : ColorTokens.darkSurfaceBright,

      // Tonal elevation restored: M3 components tint elevated surfaces with
      // `surfaceTint` (Flutter defaults to `primary`). The previous override
      // (`Colors.transparent`, for the flat shadcn look) is removed here; the
      // remaining per-widget `surfaceTintColor` overrides live in the builder
      // files and are Wave 1 scope.
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
      outline: c.input,
      outlineVariant: c.border,

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
  /// inline cross-references because `typography_tokens.dart` is OUTSIDE the
  /// Wave 0 scope boundary (4-file limit). The tokens file will be brought
  /// back into sync in a later wave; until then its `size*`/`weight*`/
  /// `tracking*` values no longer describe the live text theme.
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
