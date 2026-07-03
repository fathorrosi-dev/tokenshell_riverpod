import 'package:flutter/painting.dart';

// All values are [static const] — no runtime computation occurs here.
// Light and dark variants are separated by prefix convention.
//
// Palette swap (03 Jul 2026): replaces the previous zinc/black shadcn palette
// with the new yellow/blue brand palette. See production-readiness review
// (Theme Layer, 03 Jul 2026) for the full rationale behind every naming and
// structural decision below.
abstract final class ColorTokens {
  // ── Light mode ──────────────────────────────────────────────────────────────

  // Canvas background — Slate-50.
  static const Color lightBackground = Color(0xFFF8FAFC);

  // Default text on background — Slate-900. 17.06:1 (AAA ✓).
  static const Color lightForeground = Color(0xFF0F172A);

  // Card / panel surface — Slate-100.
  static const Color lightCard = Color(0xFFF1F5F9);

  // Text rendered on card surfaces — Slate-900. 16.30:1 (AAA ✓).
  static const Color lightCardForeground = Color(0xFF0F172A);

  // Popover / dropdown surface — Slate-50.
  static const Color lightPopover = Color(0xFFF8FAFC);

  // Text rendered inside popovers — Slate-900. 17.06:1 (AAA ✓).
  static const Color lightPopoverForeground = Color(0xFF0F172A);

  // Primary action color — Brand Yellow. Identical in both modes (brand identity, not recalculated).
  static const Color lightPrimary = Color(0xFFFCFD76);

  // Text / icon on primary surfaces — onPrimary. 16.56:1 (AAA ✓).
  static const Color lightPrimaryForeground = Color(0xFF1A1800);

  // Secondary action color — Action Blue.
  static const Color lightSecondary = Color(0xFF17B5FF);

  // Text / icon on secondary surfaces — onSecondary. 5.79:1 (AA ✓).
  static const Color lightSecondaryForeground = Color(0xFF003349);

  // Muted surface — Slate-100.
  static const Color lightMuted = Color(0xFFF1F5F9);

  // De-emphasised text — Slate-600. 6.92:1 (AA ✓).
  static const Color lightMutedForeground = Color(0xFF475569);

  // Accent / highlight surface — Primary Container (light yellow tint). Chip, badge, selected bg.
  static const Color lightAccent = Color(0xFFFEFDE8);

  // Text on accent surfaces — onPrimaryContainer. 13.84:1 (AAA ✓).
  static const Color lightAccentForeground = Color(0xFF2E2C00);

  // Secondary accent surface — Secondary Container (Sky-200). Feeds ColorScheme's
  // secondaryContainer/onSecondaryContainer (see ThemeConstants.colorSchemeFrom) —
  // not just a generic chip color, this is the designed M3 "secondary container" swatch.
  static const Color lightAccent2 = Color(0xFFBAE6FD);

  // Text on secondary accent surfaces — onSecondaryContainer. 7.13:1 (AAA ✓).
  static const Color lightAccent2Foreground = Color(0xFF0C4A6E);

  // Destructive action colour — Red-600.
  static const Color lightDestructive = Color(0xFFDC2626);

  // Text on destructive surfaces. 4.63:1 (AA ✓).
  static const Color lightDestructiveForeground = Color(0xFFFAFAFA);

  // Default border — Slate-400 (explicit "border" role in source palette).
  static const Color lightBorder = Color(0xFF94A3B8);

  // Input field border — Slate-200 (explicit "input bg" role in source palette).
  static const Color lightInput = Color(0xFFE2E8F0);

  // Focus ring colour — Brand Yellow (primary).
  static const Color lightRing = Color(0xFFFCFD76);

  // ── Dark mode ────────────────────────────────────────────────────────────────

  // Canvas background — derived cool-neutral near-black (palette is cool-dominant overall).
  static const Color darkBackground = Color(0xFF141415);

  // Default text on background. 16.81:1 (AAA ✓).
  static const Color darkForeground = Color(0xFFF1F5F9);

  // Card / panel surface — derived elevated dark surface.
  static const Color darkCard = Color(0xFF262729);

  // Text rendered on card surfaces. 13.65:1 (AAA ✓).
  static const Color darkCardForeground = Color(0xFFF1F5F9);

  // Popover / dropdown surface.
  static const Color darkPopover = Color(0xFF262729);

  // Text rendered inside popovers. 13.65:1 (AAA ✓).
  static const Color darkPopoverForeground = Color(0xFFF1F5F9);

  // Primary action color — Brand Yellow, intentionally NOT recalculated for dark mode
  // per explicit instruction: brand identity color stays identical across themes.
  static const Color darkPrimary = Color(0xFFFCFD76);

  // Text / icon on primary surfaces — onPrimary (same pairing as light mode). 16.56:1 (AAA ✓).
  static const Color darkPrimaryForeground = Color(0xFF1A1800);

  // Secondary surface — derived dark structural neutral (kept separate from the brand blue,
  // matching the original file's surface-vs-action-color convention).
  static const Color darkSecondary = Color(0xFF333538);

  // Text on secondary surfaces. 11.23:1 (AAA ✓).
  static const Color darkSecondaryForeground = Color(0xFFF1F5F9);

  // Muted surface.
  static const Color darkMuted = Color(0xFF262729);

  // De-emphasised text. 5.04:1 (AA ✓).
  static const Color darkMutedForeground = Color(0xFF949699);

  // Accent / highlight surface — Primary Container hue kept consistent across modes.
  static const Color darkAccent = Color(0xFFFEFDE8);

  // Text on accent surfaces — onPrimaryContainer (same pairing as light mode). 13.84:1 (AAA ✓).
  static const Color darkAccentForeground = Color(0xFF2E2C00);

  // Secondary accent surface — dark variant of Secondary Container. Feeds ColorScheme's
  // secondaryContainer/onSecondaryContainer in dark mode (see lightAccent2 above).
  static const Color darkAccent2 = Color(0xFF7ACFFB);

  // Text on secondary accent surfaces — onSecondaryContainer reused for brand consistency.
  // 5.47:1 (AA ✓).
  static const Color darkAccent2Foreground = Color(0xFF0C4A6E);

  // Destructive action colour — Red-600, lightened for dark-surface visibility.
  static const Color darkDestructive = Color(0xFFE24949);

  // Text on destructive surfaces. 3.81:1 (AA_large only — acceptable for buttons/banners).
  static const Color darkDestructiveForeground = Color(0xFFFAFAFA);

  // Default border.
  static const Color darkBorder = Color(0xFF424447);

  // Input field border.
  static const Color darkInput = Color(0xFF4A4C4F);

  // Focus ring colour — Primary Container, same hue kept across modes.
  static const Color darkRing = Color(0xFFFEFDE8);

  // ── Status palette ───────────────────────────────────────────────────────────
  //
  // Foreground tokens (successForeground, warningForeground, infoForeground,
  // errorForeground) are shared across brightness — a single token used for both
  // light and dark, per the source palette (unlike the old zinc palette, which
  // split every status foreground by brightness). These pair with the base fill
  // color for icon/progress use, not overlaid body text — see each field's comment.
  //
  // Container tokens (*Container / *ContainerForeground) are solid, designed
  // tonal-surface colors for badge/chip backgrounds — success, warning, and error
  // ship real container tokens from the source palette. Info does NOT — see
  // lightInfoContainer/darkInfoContainer below for the derivation used to keep
  // the four status types symmetric in the theme-layer model.

  // Success — Green-600 family (Quota < 70%). Progress bar / icon fill.
  static const Color lightSuccess = Color(0xFF16A34A);
  // 3.00:1 (AA_large) against successForeground — use successContainer pairing for body text.
  static const Color darkSuccess = Color(0xFF21C65E);
  // 2.26:1 against white — fill is for icons/progress, not overlaid text; pair with container instead.
  static const Color successForeground = Color(0xFFFFFFFF);

  // Success container — light card/badge tint.
  static const Color lightSuccessContainer = Color(0xFFDCFCE7);
  // Success container — dark tonal surface.
  static const Color darkSuccessContainer = Color(0xFF254B33);
  // Text/icon on light success container — reuses successFill. 3.00:1 (AA_large).
  static const Color lightSuccessContainerForeground = Color(0xFF16A34A);
  // Text/icon on dark success container. 7.71:1 (AAA ✓).
  static const Color darkSuccessContainerForeground = Color(0xFFD9E7DF);

  // Warning — Amber-700 family (Quota 70–90%). Progress bar / icon fill.
  static const Color lightWarning = Color(0xFFB45309);
  // 4.86:1 (AA ✓) against warningForeground.
  static const Color darkWarning = Color(0xFFD46917);
  static const Color warningForeground = Color(0xFF1C1917);

  // Warning container — light card/badge tint.
  static const Color lightWarningContainer = Color(0xFFFEF3C7);
  // Warning container — dark tonal surface.
  static const Color darkWarningContainer = Color(0xFF4F3521);
  // Text/icon on light warning container — reuses warningFill. 4.51:1 (AA ✓).
  static const Color lightWarningContainerForeground = Color(0xFFB45309);
  // Text/icon on dark warning container. 8.59:1 (AAA ✓).
  static const Color darkWarningContainerForeground = Color(0xFFE9DFD8);

  // Info — derived from Action Blue hue family (no explicit info color supplied; secondary
  // is already used as the info icon color per the source palette legend).
  static const Color lightInfo = Color(0xFF0E5EA0);
  // 6.71:1 (AA ✓, near-AAA) against infoForeground.
  static const Color darkInfo = Color(0xFF4099E2);
  // 3.06:1 (AA_large) against infoForeground.
  static const Color infoForeground = Color(0xFFFFFFFF);

  // Info container — NOT supplied by the source palette (unlike success/warning/error).
  // Derived as a 15% alpha tint of lightInfo/darkInfo — the exact same
  // OpacityTokens.containerTint value already used for ColorScheme.tertiaryContainer
  // in ThemeConstants.colorSchemeFrom. Expressed as a plain ARGB literal (alpha byte
  // 0x26 ≈ 15% of 255) instead of `.withValues()` so it stays a true compile-time
  // constant, consumable from the const AppStatusColors snapshots in ThemeConstants.
  // Flag back to design if a real infoContainer token becomes available later.
  static const Color lightInfoContainer = Color(0x260E5EA0);
  static const Color darkInfoContainer = Color(0x264099E2);
  // Text/icon on info container — reuses infoFill, matching the reuse pattern used
  // by every other status container above. Approximate contrast only (semi-transparent
  // container composites differently depending on what's behind it) — not a precise
  // measured ratio like the opaque container pairs above.
  // (No separate constant: AppStatusColors.infoContainerForeground references
  // lightInfo/darkInfo directly in ThemeConstants — see status construction there.)

  // Error — Red-600 family (Quota > 90%). Same brand red as destructive. Progress bar / icon fill.
  static const Color lightError = Color(0xFFDC2626);
  // 3.98:1 (AA_large) against errorForeground.
  static const Color darkError = Color(0xFFE24949);
  static const Color errorForeground = Color(0xFFFFFFFF);

  // Error container — light card/badge tint. Also feeds ColorScheme.errorContainer
  // in light mode (see ThemeConstants.colorSchemeFrom) — single source of truth
  // shared between the M3-native error path and the custom status-badge path.
  static const Color lightErrorContainer = Color(0xFFFEE2E2);
  // Error container — dark tonal surface. Also feeds ColorScheme.errorContainer
  // in dark mode.
  static const Color darkErrorContainer = Color(0xFF4A2626);
  // Text/icon on light error container — reuses dangerFill. 3.95:1 (AA_large).
  // Also feeds ColorScheme.onErrorContainer in light mode.
  static const Color lightErrorContainerForeground = Color(0xFFDC2626);
  // Text/icon on dark error container. 9.67:1 (AAA ✓). Also feeds
  // ColorScheme.onErrorContainer in dark mode.
  static const Color darkErrorContainerForeground = Color(0xFFE7DADA);
}
