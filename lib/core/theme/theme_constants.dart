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

  static const AppThemeColors lightColors = AppThemeColors(
    background: ColorTokens.lightBackground,
    foreground: ColorTokens.lightForeground,
    card: ColorTokens.lightCard,
    cardForeground: ColorTokens.lightCardForeground,
    popover: ColorTokens.lightPopover,
    popoverForeground: ColorTokens.lightPopoverForeground,
    primary: ColorTokens.lightPrimary,
    primaryForeground: ColorTokens.lightPrimaryForeground,
    secondary: ColorTokens.lightSecondary,
    secondaryForeground: ColorTokens.lightSecondaryForeground,
    muted: ColorTokens.lightMuted,
    mutedForeground: ColorTokens.lightMutedForeground,
    accent: ColorTokens.lightAccent,
    accentForeground: ColorTokens.lightAccentForeground,
    destructive: ColorTokens.lightDestructive,
    destructiveForeground: ColorTokens.lightDestructiveForeground,
    border: ColorTokens.lightBorder,
    input: ColorTokens.lightInput,
    ring: ColorTokens.lightRing,
    status: AppStatusColors(
      success: ColorTokens.lightSuccess,
      successForeground: ColorTokens.lightSuccessForeground,
      warning: ColorTokens.lightWarning,
      warningForeground: ColorTokens.lightWarningForeground,
      info: ColorTokens.lightInfo,
      infoForeground: ColorTokens.lightInfoForeground,
      error: ColorTokens.lightError,
      errorForeground: ColorTokens.lightErrorForeground,
    ),
  );

  static const AppThemeColors darkColors = AppThemeColors(
    background: ColorTokens.darkBackground,
    foreground: ColorTokens.darkForeground,
    card: ColorTokens.darkCard,
    cardForeground: ColorTokens.darkCardForeground,
    popover: ColorTokens.darkPopover,
    popoverForeground: ColorTokens.darkPopoverForeground,
    primary: ColorTokens.darkPrimary,
    primaryForeground: ColorTokens.darkPrimaryForeground,
    secondary: ColorTokens.darkSecondary,
    secondaryForeground: ColorTokens.darkSecondaryForeground,
    muted: ColorTokens.darkMuted,
    mutedForeground: ColorTokens.darkMutedForeground,
    accent: ColorTokens.darkAccent,
    accentForeground: ColorTokens.darkAccentForeground,
    destructive: ColorTokens.darkDestructive,
    destructiveForeground: ColorTokens.darkDestructiveForeground,
    border: ColorTokens.darkBorder,
    input: ColorTokens.darkInput,
    ring: ColorTokens.darkRing,
    status: AppStatusColors(
      success: ColorTokens.darkSuccess,
      successForeground: ColorTokens.darkSuccessForeground,
      warning: ColorTokens.darkWarning,
      warningForeground: ColorTokens.darkWarningForeground,
      info: ColorTokens.darkInfo,
      infoForeground: ColorTokens.darkInfoForeground,
      error: ColorTokens.darkError,
      errorForeground: ColorTokens.darkErrorForeground,
    ),
  );

  // ── ColorScheme factory ───────────────────────────────────────────────────────

  /// Builds a Material 3 [ColorScheme] fully mapped from shadcn/ui tokens.
  ///
  /// Mapping priority: shadcn/ui visual intent wins; M3 role names are used
  /// as structural scaffolding only. Widgets that haven't been explicitly themed
  /// in [AppTheme] will fall back to these role mappings — audit those widgets
  /// if they look inconsistent with the shadcn feel.
  static ColorScheme colorSchemeFrom(
    AppThemeColors c,
    Brightness brightness,
  ) {
    return ColorScheme(
      brightness: brightness,

      // Primary — mapped to shadcn `primary`
      primary: c.primary,
      onPrimary: c.primaryForeground,
      primaryContainer: c.secondary,
      onPrimaryContainer: c.secondaryForeground,
      // `*Fixed` / `*FixedDim` roles below are unconditionally sourced from
      // the LIGHT palette constants, never from `c` — M3's contract for
      // these roles is that they stay the SAME color regardless of which
      // brightness the rest of the scheme resolves to (e.g. a status badge
      // that must look identical in light and dark mode). Using `c` here
      // would silently break that contract the moment this method runs for
      // `Brightness.dark`. shadcn/ui has no equivalent "theme-invariant"
      // concept, so these are a deliberate, simple approximation — not a
      // precise M3 tonal-palette derivation — added so a future M3 widget
      // that reads them directly inherits a chosen value instead of
      // Flutter's auto-computed tonal default.
      primaryFixed: ColorTokens.lightSecondary,
      primaryFixedDim: ColorTokens.lightPrimary,
      onPrimaryFixed: ColorTokens.lightSecondaryForeground,
      onPrimaryFixedVariant: ColorTokens.lightMutedForeground,

      // Secondary — mapped to shadcn `secondary` (surface-like in shadcn)
      secondary: c.secondary,
      onSecondary: c.secondaryForeground,
      secondaryContainer: c.muted,
      onSecondaryContainer: c.mutedForeground,
      secondaryFixed: ColorTokens.lightMuted,
      secondaryFixedDim: ColorTokens.lightSecondary,
      onSecondaryFixed: ColorTokens.lightSecondaryForeground,
      onSecondaryFixedVariant: ColorTokens.lightMutedForeground,

      // Tertiary — mapped to shadcn `accent`
      // tertiaryContainer uses a semi-transparent tint of accent so M3 widgets
      // that rely on container/base distinction have a visually distinct surface.
      tertiary: c.accent,
      onTertiary: c.accentForeground,
      tertiaryContainer: c.accent.withValues(alpha: 0.15),
      onTertiaryContainer: c.accentForeground,
      tertiaryFixed: ColorTokens.lightAccent,
      tertiaryFixedDim: ColorTokens.lightAccent,
      onTertiaryFixed: ColorTokens.lightAccentForeground,
      onTertiaryFixedVariant: ColorTokens.lightAccentForeground,

      // Error — mapped to shadcn `destructive`
      error: c.destructive,
      onError: c.destructiveForeground,
      // Semi-transparent destructive fill for error containers.
      errorContainer: c.destructive.withValues(
        alpha: OpacityTokens.errorContainer,
      ),
      onErrorContainer: c.destructive,

      // Surface hierarchy — shadcn/ui has three meaningful surface tiers:
      // background, card, and muted. The M3 spec defines five container tiers
      // (Lowest → Highest) to convey elevation. The mapping strategy below
      // preserves shadcn's intentionally flat aesthetic while giving M3 widgets
      // a real — if subtle — distinction between adjacent tiers.
      //
      // Lowest = background (0 dp — canvas, behind everything)
      // Low    = 40% blend toward card  (1 dp — slightly raised panels)
      // Base   = card                   (2 dp — default cards)
      // High   = 60% blend toward muted (3 dp — elevated cards)
      // Highest = muted                 (4 dp — most elevated, chips, tooltips)
      //
      // In light mode background == card (both #FFFFFF), so Lowest == Low
      // and the visual difference is imperceptible — this is intentional;
      // shadcn light mode is a pure white canvas with no elevation tint.
      // In dark mode the blends produce visible but subtle gradations
      // between #030712 and #111827 (background → card) and between
      // #111827 and #18181B (card → muted), matching shadcn's dark palette.
      //
      // If a future M3 component requires a more dramatic elevation delta
      // (e.g. search bars, side sheets, modal drawers), revisit by adjusting
      // the blend fractions or introducing a dedicated midtone token.
      surface: c.background,
      onSurface: c.foreground,
      onSurfaceVariant: c.mutedForeground,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: Color.lerp(c.background, c.card, 0.4),
      surfaceContainer: c.card,
      surfaceContainerHigh: Color.lerp(c.card, c.muted, 0.6),
      surfaceContainerHighest: c.muted,
      // `surfaceDim`/`surfaceBright` anchor the darkest/lightest ends of
      // that same hierarchy — `background` (the canvas, least "lifted")
      // and `muted` (the most "lifted" tier) respectively. Not a precise
      // M3 tonal derivation, just a deliberate pick from existing tokens
      // instead of leaving these unset.
      surfaceDim: c.background,
      surfaceBright: c.muted,
      // Tonal-elevation tinting is switched off everywhere at the widget
      // level (`surfaceTintColor: Colors.transparent` on every surface
      // widget in `surface_theme_builder.dart` / `navigation_theme_builder.dart`)
      // to preserve the flat shadcn look. Mirrored here so a widget that
      // reads `colorScheme.surfaceTint` directly — instead of the explicit
      // per-widget override — gets the same "no tint" intent.
      surfaceTint: Colors.transparent,

      // Inverse surfaces
      inverseSurface: c.foreground,
      onInverseSurface: c.background,
      inversePrimary: c.primaryForeground,

      // Borders and overlays
      // outline      → component borders (full-weight).
      // outlineVariant → decorative dividers / lighter separators (half-opacity).
      outline: c.border,
      outlineVariant: c.border.withValues(alpha: 0.5),

      // Scrim / shadow — always opaque black
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
    );
  }

  // ── TextTheme factory ─────────────────────────────────────────────────────────

  /// Builds a [TextTheme] using [TypographyTokens] (Geist font family).
  ///
  /// The [foreground] color is applied to all roles; widget-level overrides
  /// (e.g. muted hint text) are applied inside [AppTheme]'s widget theme configs.
  static TextTheme textThemeFrom(Color foreground) {
    return TextTheme(
      // Display — large hero text, light weight, very tight tracking
      displayLarge: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.size6xl,
        fontWeight: TypographyTokens.weightLight,
        letterSpacing: TypographyTokens.trackingTighter,
        height: TypographyTokens.leadingTight,
        color: foreground,
      ),
      displayMedium: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.size5xl,
        fontWeight: TypographyTokens.weightLight,
        letterSpacing: TypographyTokens.trackingTighter,
        height: TypographyTokens.leadingTight,
        color: foreground,
      ),
      displaySmall: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.size4xl,
        fontWeight: TypographyTokens.weightRegular,
        letterSpacing: TypographyTokens.trackingTight,
        height: TypographyTokens.leadingTight,
        color: foreground,
      ),

      // Headline — section headers, semi-bold, tight
      headlineLarge: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.size3xl,
        fontWeight: TypographyTokens.weightSemiBold,
        letterSpacing: TypographyTokens.trackingTight,
        height: TypographyTokens.leadingTight,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.size2xl,
        fontWeight: TypographyTokens.weightSemiBold,
        letterSpacing: TypographyTokens.trackingTight,
        height: TypographyTokens.leadingSnug,
        color: foreground,
      ),
      headlineSmall: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeXl,
        fontWeight: TypographyTokens.weightSemiBold,
        letterSpacing: TypographyTokens.trackingTight,
        height: TypographyTokens.leadingSnug,
        color: foreground,
      ),

      // Title — component headers
      titleLarge: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeLg,
        fontWeight: TypographyTokens.weightSemiBold,
        letterSpacing: TypographyTokens.trackingTight,
        height: TypographyTokens.leadingSnug,
        color: foreground,
      ),
      titleMedium: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeMd,
        fontWeight: TypographyTokens.weightMedium,
        letterSpacing: TypographyTokens.trackingNormal,
        height: TypographyTokens.leadingNormal,
        color: foreground,
      ),
      titleSmall: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeSm,
        fontWeight: TypographyTokens.weightMedium,
        letterSpacing: TypographyTokens.trackingNormal,
        height: TypographyTokens.leadingNormal,
        color: foreground,
      ),

      // Label — buttons, tabs, chips
      labelLarge: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeSm,
        fontWeight: TypographyTokens.weightMedium,
        letterSpacing: TypographyTokens.trackingNormal,
        height: TypographyTokens.leadingNormal,
        color: foreground,
      ),
      labelMedium: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeXs,
        fontWeight: TypographyTokens.weightMedium,
        letterSpacing: TypographyTokens.trackingWide,
        height: TypographyTokens.leadingNormal,
        color: foreground,
      ),
      labelSmall: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeXxs,
        fontWeight: TypographyTokens.weightMedium,
        letterSpacing: TypographyTokens.trackingWide,
        height: TypographyTokens.leadingNormal,
        color: foreground,
      ),

      // Body — readable prose
      bodyLarge: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeMd,
        fontWeight: TypographyTokens.weightRegular,
        letterSpacing: TypographyTokens.trackingNormal,
        height: TypographyTokens.leadingRelaxed,
        color: foreground,
      ),
      bodyMedium: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeSm,
        fontWeight: TypographyTokens.weightRegular,
        letterSpacing: TypographyTokens.trackingNormal,
        height: TypographyTokens.leadingRelaxed,
        color: foreground,
      ),
      bodySmall: TextStyle(
        fontFamily: TypographyTokens.fontFamily,
        fontFamilyFallback: TypographyTokens.fontFamilyFallback,
        fontSize: TypographyTokens.sizeXs,
        fontWeight: TypographyTokens.weightRegular,
        letterSpacing: TypographyTokens.trackingNormal,
        height: TypographyTokens.leadingRelaxed,
        color: foreground,
      ),
    );
  }
}
