import 'package:flutter/painting.dart';

/// All values are [static const] — no runtime computation occurs here.
/// Light and dark variants are separated by prefix convention.
abstract final class ColorTokens {
  // ── Light mode ──────────────────────────────────────────────────────────────

  /// Canvas background — pure white.
  static const Color lightBackground = Color(0xFFFFFFFF);

  /// Default text on background.
  static const Color lightForeground = Color(0xFF030712);

  /// Card / panel surface — same as background in light mode.
  static const Color lightCard = Color(0xFFFFFFFF);

  /// Text rendered on card surfaces.
  static const Color lightCardForeground = Color(0xFF030712);

  /// Popover / dropdown surface.
  static const Color lightPopover = Color(0xFFFFFFFF);

  /// Text rendered inside popovers.
  static const Color lightPopoverForeground = Color(0xFF030712);

  /// Primary action color — near-black zinc-900.
  static const Color lightPrimary = Color(0xFF18181B);

  /// Text / icon on primary surfaces.
  static const Color lightPrimaryForeground = Color(0xFFFAFAFA);

  /// Secondary surface — zinc-100.
  static const Color lightSecondary = Color(0xFFF4F4F5);

  /// Text on secondary surfaces.
  static const Color lightSecondaryForeground = Color(0xFF18181B);

  /// Muted surface — zinc-100.
  static const Color lightMuted = Color(0xFFF4F4F5);

  /// De-emphasised text — zinc-500.
  static const Color lightMutedForeground = Color(0xFF71717A);

  /// Accent hover / highlight surface — zinc-100.
  static const Color lightAccent = Color(0xFFF4F4F5);

  /// Text on accent surfaces.
  static const Color lightAccentForeground = Color(0xFF18181B);

  /// Destructive action colour — red-500.
  static const Color lightDestructive = Color(0xFFEF4444);

  /// Text on destructive surfaces.
  static const Color lightDestructiveForeground = Color(0xFFFAFAFA);

  /// Default border — zinc-200.
  static const Color lightBorder = Color(0xFFE4E4E7);

  /// Input field border — zinc-200.
  static const Color lightInput = Color(0xFFE4E4E7);

  /// Focus ring colour — zinc-900.
  static const Color lightRing = Color(0xFF18181B);

  // ── Dark mode ────────────────────────────────────────────────────────────────

  /// Canvas background — near-black gray-950.
  static const Color darkBackground = Color(0xFF030712);

  /// Default text on background — gray-50.
  static const Color darkForeground = Color(0xFFF9FAFB);

  /// Card / panel surface — gray-900.
  static const Color darkCard = Color(0xFF111827);

  /// Text rendered on card surfaces — gray-50.
  static const Color darkCardForeground = Color(0xFFF9FAFB);

  /// Popover / dropdown surface — gray-900.
  static const Color darkPopover = Color(0xFF111827);

  /// Text rendered inside popovers — gray-50.
  static const Color darkPopoverForeground = Color(0xFFF9FAFB);

  /// Primary action color — near-white zinc-50.
  static const Color darkPrimary = Color(0xFFFAFAFA);

  /// Text / icon on primary surfaces — zinc-900.
  static const Color darkPrimaryForeground = Color(0xFF18181B);

  /// Secondary surface — gray-800.
  static const Color darkSecondary = Color(0xFF1F2937);

  /// Text on secondary surfaces — gray-50.
  static const Color darkSecondaryForeground = Color(0xFFF9FAFB);

  /// Muted surface — zinc-900.
  static const Color darkMuted = Color(0xFF18181B);

  /// De-emphasised text — gray-400.
  static const Color darkMutedForeground = Color(0xFF9CA3AF);

  /// Accent hover / highlight surface — zinc-900.
  static const Color darkAccent = Color(0xFF18181B);

  /// Text on accent surfaces — gray-50.
  static const Color darkAccentForeground = Color(0xFFF9FAFB);

  /// Destructive action colour — red-500 (same in both modes).
  static const Color darkDestructive = Color(0xFFEF4444);

  /// Text on destructive surfaces.
  static const Color darkDestructiveForeground = Color(0xFFFAFAFA);

  /// Default border — zinc-800.
  static const Color darkBorder = Color(0xFF27272A);

  /// Input field border — gray-700.
  static const Color darkInput = Color(0xFF374151);

  /// Focus ring colour — zinc-300.
  static const Color darkRing = Color(0xFFD4D4D8);

  // ── Status palette ───────────────────────────────────────────────────────────

  // Success — Emerald family
  static const Color lightSuccess = Color(0xFF10B981); // emerald-500
  static const Color darkSuccess = Color(0xFF34D399); // emerald-400
  static const Color successForeground = Color(0xFFFFFFFF);

  // Warning — Amber family
  static const Color lightWarning = Color(0xFFF59E0B); // amber-500
  static const Color darkWarning = Color(0xFFFBBF24); // amber-400
  static const Color warningForeground = Color(0xFF1C1917); // stone-950

  // Info — Sky family
  static const Color lightInfo = Color(0xFF0EA5E9); // sky-500
  static const Color darkInfo = Color(0xFF38BDF8); // sky-400
  static const Color infoForeground = Color(0xFFFFFFFF);

  // Error — Rose family
  static const Color lightError = Color(0xFFF43F5E); // rose-500
  static const Color darkError = Color(0xFFFB7185); // rose-400
  static const Color errorForeground = Color(0xFFFFFFFF);
}
