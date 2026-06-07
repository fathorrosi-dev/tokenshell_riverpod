import 'package:flutter/material.dart';

import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';

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
    success: ColorTokens.lightSuccess,
    successForeground: ColorTokens.successForeground,
    warning: ColorTokens.lightWarning,
    warningForeground: ColorTokens.warningForeground,
    info: ColorTokens.lightInfo,
    infoForeground: ColorTokens.infoForeground,
    error: ColorTokens.lightError,
    errorForeground: ColorTokens.errorForeground,
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
    success: ColorTokens.darkSuccess,
    successForeground: ColorTokens.successForeground,
    warning: ColorTokens.darkWarning,
    warningForeground: ColorTokens.warningForeground,
    info: ColorTokens.darkInfo,
    infoForeground: ColorTokens.infoForeground,
    error: ColorTokens.darkError,
    errorForeground: ColorTokens.errorForeground,
  );

  // ── ColorScheme factory ───────────────────────────────────────────────────────

  /// Builds a Material 3 [ColorScheme] fully mapped from shadcn/ui tokens.
  ///
  /// The mapping priority follows the tiebreaker rule:
  /// shadcn/ui visual wins; Material 3 API structure is used as scaffolding.
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

      // Secondary — mapped to shadcn `secondary` (surface-like in shadcn)
      secondary: c.secondary,
      onSecondary: c.secondaryForeground,
      secondaryContainer: c.muted,
      onSecondaryContainer: c.mutedForeground,

      // Tertiary — mapped to shadcn `accent`
      tertiary: c.accent,
      onTertiary: c.accentForeground,
      tertiaryContainer: c.accent,
      onTertiaryContainer: c.accentForeground,

      // Error — mapped to shadcn `destructive`
      error: c.destructive,
      onError: c.destructiveForeground,
      errorContainer: c.destructive.withValues(alpha: 0.15),
      onErrorContainer: c.destructive,

      // Surface hierarchy — mapped from shadcn background/card/muted
      surface: c.background,
      onSurface: c.foreground,
      onSurfaceVariant: c.mutedForeground,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: c.background,
      surfaceContainer: c.card,
      surfaceContainerHigh: c.card,
      surfaceContainerHighest: c.muted,

      // Inverse surfaces
      inverseSurface: c.foreground,
      onInverseSurface: c.background,
      inversePrimary: c.primaryForeground,

      // Borders and overlays
      outline: c.border,
      outlineVariant: c.border,

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
        fontSize: 11,
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
