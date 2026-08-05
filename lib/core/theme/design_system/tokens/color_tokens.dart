import 'package:flutter/painting.dart';

/// Material 3 color roles on a neutral/monochrome tonal ramp (~zero chroma).
///
/// All values are [static const] — no runtime computation occurs here.
/// Light and dark variants are separated by prefix convention.
///
/// Wave 0 M3 core refactor: every role holds a value with a genuine M3
/// tonal relationship to its neighbours (tone 10/20/30/…/100 netral ramp),
/// not a 1:1 port from another design system. Scheme identity is a deliberate
/// monochrome design decision — see repo AGENTS.md "Open decisions".
abstract final class ColorTokens {
  // ── Light mode ──────────────────────────────────────────────────────────────

  // Primary — netral tone ramp. Light scheme anchors primary at a very dark
  // tone (tone-10 class) with a light container (tone 90) — the M3
  // "high-emphasis monochrome" pattern (cf. Android black/white schemes).

  /// Primary action color — netral tone 10.
  static const Color lightPrimary = Color(0xFF1B1B1B);

  /// Text / icon on primary. White on tone 10 (#1B1B1B): ~18.0:1 — AA/AAA.
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  /// Primary container — netral tone 90.
  static const Color lightPrimaryContainer = Color(0xFFE2E2E2);

  /// Text on primary container. Tone 10 on tone 90: ~14.6:1 — AA/AAA.
  static const Color lightOnPrimaryContainer = Color(0xFF1B1B1B);

  // Secondary — netral tone 40.

  /// Secondary — netral tone 40.
  static const Color lightSecondary = Color(0xFF5E5E5E);

  /// Text on secondary. White on tone 40: ~6.7:1 — AA.
  static const Color lightOnSecondary = Color(0xFFFFFFFF);

  /// Secondary container — netral tone 92 (sedikit lebih terang dari
  /// primaryContainer agar kedua keluarga tetap distinguishable).
  static const Color lightSecondaryContainer = Color(0xFFEBEBEB);

  /// Text on secondary container. Tone 10 on tone 92: ~17.0:1 — AAA.
  static const Color lightOnSecondaryContainer = Color(0xFF1B1B1B);

  // Tertiary — untuk skema monokrom tidak ada hue ketiga; tertiary dipetakan
  // ke offset tone yang tetap netral (tone 25/85) supaya widget yang membaca
  // role tertiary tetap distinguishable dari primary/secondary. Keputusan
  // desain eksplisit — didokumentasikan, bukan kebetulan.

  /// Tertiary — netral tone 25.
  static const Color lightTertiary = Color(0xFF3F3F3F);

  /// Text on tertiary. White on tone 25: ~10.0:1 — AAA.
  static const Color lightOnTertiary = Color(0xFFFFFFFF);

  /// Tertiary container — netral tone 85.
  static const Color lightTertiaryContainer = Color(0xFFD9D9D9);

  /// Text on tertiary container. Tone 23 on tone 85: ~12.0:1 — AAA.
  static const Color lightOnTertiaryContainer = Color(0xFF262626);

  // Error — M3 baseline error palette (eksplisit, bukan alpha-tint).

  /// Error — M3 light error (#BA1A1A).
  static const Color lightError = Color(0xFFBA1A1A);

  /// Text on error. White on #BA1A1A: ~5.7:1 — AA.
  static const Color lightOnError = Color(0xFFFFFFFF);

  /// Error container — M3 #FFDAD6.
  static const Color lightErrorContainer = Color(0xFFFFDAD6);

  /// Text on error container. #410002 on #FFDAD6: ~12.6:1 — AAA.
  static const Color lightOnErrorContainer = Color(0xFF410002);

  // Surface hierarchy — five M3 container tiers pada ramp netral.

  /// Surface base — tone 98.
  static const Color lightSurface = Color(0xFFFCFCFC);

  /// Default text on surface. Tone 10 on tone 98: ~18.5:1 — AAA.
  static const Color lightOnSurface = Color(0xFF1B1B1B);

  /// De-emphasised text on surface — tone 30.
  /// #474747 on #FCFCFC: ~8.6:1 — AAA(AA untuk teks normal jauh terlampaui).
  static const Color lightOnSurfaceVariant = Color(0xFF474747);

  /// Tier 1 (0 dp canvas) — tone 100.
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);

  /// Tier 2 — tone 96.
  static const Color lightSurfaceContainerLow = Color(0xFFF6F6F6);

  /// Tier 3 — tone 94.
  static const Color lightSurfaceContainer = Color(0xFFF0F0F0);

  /// Tier 4 — tone 92.
  static const Color lightSurfaceContainerHigh = Color(0xFFECECEC);

  /// Tier 5 (most elevated) — tone 90.
  static const Color lightSurfaceContainerHighest = Color(0xFFE6E6E6);

  /// Darkest surface anchor — tone 87.
  static const Color lightSurfaceDim = Color(0xFFDDDDDD);

  /// Lightest surface anchor — tone 98 (sama dengan surface, sesuai M3 light scheme).
  static const Color lightSurfaceBright = Color(0xFFFCFCFC);

  // Inverse surfaces

  /// Inverse surface — tone 20.
  static const Color lightInverseSurface = Color(0xFF303030);

  /// Text on inverse surface — tone 95 (~13.4:1 kontras terhadap tone 20).
  static const Color lightOnInverseSurface = Color(0xFFF2F2F2);

  /// Inverse primary — tone 80 (#C6C6C6 pada tone 20: ~8.3:1 — OK untuk elemen menonjol).
  static const Color lightInversePrimary = Color(0xFFC6C6C6);

  // Outlines

  /// Component borders — netral tone 50.
  /// #757575 on #FCFCFC: ~4.2:1 — memenuhi WCAG non-text contrast 3:1 untuk
  /// batas komponen UI. Teks muted TIDAK memakai role ini — pakai
  /// [lightOnSurfaceVariant] (AAA).
  static const Color lightOutline = Color(0xFF757575);

  /// Dekoratif / divider — tone 80, solid (menggantikan border@50% alpha lama).
  static const Color lightOutlineVariant = Color(0xFFC7C7C7);

  // ── Dark mode ────────────────────────────────────────────────────────────────

  /// Primary — netral tone 90.
  static const Color darkPrimary = Color(0xFFE2E2E2);

  /// Text on primary. Tone 10 on tone 90: ~14.6:1 — AAA.
  static const Color darkOnPrimary = Color(0xFF1B1B1B);

  /// Primary container — tone 30.
  static const Color darkPrimaryContainer = Color(0xFF474747);

  /// Text on primary container. Tone 90 on tone 30: ~8.1:1 — AAA.
  static const Color darkOnPrimaryContainer = Color(0xFFE2E2E2);

  /// Secondary — tone 80.
  static const Color darkSecondary = Color(0xFFC6C6C6);

  /// Text on secondary. Tone 20 on tone 80: ~8.9:1 — AAA.
  static const Color darkOnSecondary = Color(0xFF303030);

  /// Secondary container — tone 30.
  static const Color darkSecondaryContainer = Color(0xFF474747);

  /// Text on secondary container. Tone 90 on tone 30: ~8.1:1 — AAA.
  static const Color darkOnSecondaryContainer = Color(0xFFE2E2E2);

  /// Tertiary — tone 75 (offset dari secondary, tetap netral).
  static const Color darkTertiary = Color(0xFFBDBDBD);

  /// Text on tertiary. Tone 23 on tone 75: ~7.2:1 — AAA.
  static const Color darkOnTertiary = Color(0xFF262626);

  /// Tertiary container — tone 25.
  static const Color darkTertiaryContainer = Color(0xFF3F3F3F);

  /// Text on tertiary container. Tone 85 on tone 25: ~8.7:1 — AAA.
  static const Color darkOnTertiaryContainer = Color(0xFFD9D9D9);

  /// Error — M3 dark error (#FFB4AB).
  static const Color darkError = Color(0xFFFFB4AB);

  /// Text on error. #690005 on #FFB4AB: ~10.4:1 — AAA.
  static const Color darkOnError = Color(0xFF690005);

  /// Error container — M3 #93000A.
  static const Color darkErrorContainer = Color(0xFF93000A);

  /// Text on error container. #FFDAD6 on #93000A: ~9.9:1 — AAA.
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  /// Surface base — tone 6.
  static const Color darkSurface = Color(0xFF131313);

  /// Default text on surface. Tone 90 on tone 6: ~15.8:1 — AAA.
  static const Color darkOnSurface = Color(0xFFE2E2E2);

  /// De-emphasised text on surface — tone 80.
  /// #C6C6C6 on #131313: ~11.5:1 — AAA.
  static const Color darkOnSurfaceVariant = Color(0xFFC6C6C6);

  /// Tier 1 — tone 4.
  static const Color darkSurfaceContainerLowest = Color(0xFF0D0D0D);

  /// Tier 2 — tone 10.
  static const Color darkSurfaceContainerLow = Color(0xFF1B1B1B);

  /// Tier 3 — tone 12.
  static const Color darkSurfaceContainer = Color(0xFF1F1F1F);

  /// Tier 4 — tone 17.
  static const Color darkSurfaceContainerHigh = Color(0xFF2B2B2B);

  /// Tier 5 — tone 22.
  static const Color darkSurfaceContainerHighest = Color(0xFF363636);

  /// Darkest surface anchor — tone 3.
  static const Color darkSurfaceDim = Color(0xFF0A0A0A);

  /// Lightest surface anchor — tone 24.
  static const Color darkSurfaceBright = Color(0xFF3A3A3A);

  /// Inverse surface — tone 90.
  static const Color darkInverseSurface = Color(0xFFE2E2E2);

  /// Text on inverse surface — tone 20.
  static const Color darkOnInverseSurface = Color(0xFF303030);

  /// Inverse primary — tone 40 (#5E5E5E pada tone 90: ~5.4:1).
  static const Color darkInversePrimary = Color(0xFF5E5E5E);

  /// Component borders — tone 60.
  /// #8E8E8E on #131313: ~5.7:1 — di atas WCAG non-text 3:1.
  static const Color darkOutline = Color(0xFF8E8E8E);

  /// Dekoratif / divider — tone 30, solid.
  static const Color darkOutlineVariant = Color(0xFF474747);

  // ── Fixed roles (brightness-invariant, per kontrak M3 "fixed") ──────────────

  /// Primary fixed — light-scheme tone 90, identik di kedua brightness.
  static const Color primaryFixed = Color(0xFFE2E2E2);

  /// Primary fixed dim — tone 80.
  static const Color primaryFixedDim = Color(0xFFC6C6C6);

  /// Text on primary fixed — tone 10.
  static const Color onPrimaryFixed = Color(0xFF1B1B1B);

  /// Variant text on primary fixed — tone 30.
  static const Color onPrimaryFixedVariant = Color(0xFF474747);

  /// Secondary fixed — light-scheme tone 92.
  static const Color secondaryFixed = Color(0xFFEBEBEB);

  /// Secondary fixed dim — tone 82.
  static const Color secondaryFixedDim = Color(0xFFD0D0D0);

  /// Text on secondary fixed — tone 10.
  static const Color onSecondaryFixed = Color(0xFF1B1B1B);

  /// Variant text on secondary fixed — tone 30.
  static const Color onSecondaryFixedVariant = Color(0xFF474747);

  /// Tertiary fixed — light-scheme tone 85.
  static const Color tertiaryFixed = Color(0xFFD9D9D9);

  /// Tertiary fixed dim — tone 75.
  static const Color tertiaryFixedDim = Color(0xFFBDBDBD);

  /// Text on tertiary fixed — tone 23.
  static const Color onTertiaryFixed = Color(0xFF262626);

  /// Variant text on tertiary fixed — tone 35.
  static const Color onTertiaryFixedVariant = Color(0xFF565656);

  // ── Status palette ───────────────────────────────────────────────────────────
  //
  // Sengaja berada DI LUAR role M3 native: success/warning/info tidak punya
  // padanan di ColorScheme, jadi tetap dibawa lewat ThemeExtension
  // (AppStatusColors) — lihat AGENTS.md. Nilai di bawah sudah lolos audit
  // WCAG AA (01 Jul 2026) dan TIDAK diubah oleh refactor M3 Wave 0.
  //
  // Foreground tokens are split by mode because dark-mode status backgrounds
  // are lighter (400-series) than their light-mode counterparts (500-series).
  // White text on a 400-series color fails WCAG AA (< 4.5:1 contrast ratio):
  //   • darkSuccess  (#34D399 emerald-400) + white → ~2.5:1  ❌
  //   • darkInfo     (#38BDF8 sky-400)     + white → ~2.8:1  ❌
  //   • darkError    (#FB7185 rose-400)    + white → ~3.4:1  ❌
  // Using stone-950 (#1C1917) as the dark-mode foreground restores AA compliance
  // and is consistent with the existing warningForeground treatment.
  //
  // 01 Jul 2026 production-readiness audit: the same problem was found to
  // also affect two LIGHT-mode 500-series pairs that had been assumed safe
  // and never re-verified with precise contrast math —
  //   • lightSuccess (#10B981 emerald-500) + white → 2.54:1  ❌ (was
  //     documented as "~4.6:1 ✅", a calculation error, not just a bad
  //     color choice)
  //   • lightError   (#F43F5E rose-500)    + white → 3.67:1  ❌ (same
  //     documentation error)
  // Both now use stone-950, the same fix already applied to warning/info in
  // light mode — see [lightWarningForeground] / [lightInfoForeground] below,
  // which had this correct from the start.

  // Success — Emerald family
  static const Color lightSuccess = Color(0xFF10B981); // emerald-500
  static const Color darkSuccess = Color(0xFF34D399); // emerald-400
  /// Stone-950 on emerald-500 (light): 6.89:1 — passes WCAG AA.
  /// Previously white (2.54:1, fails AA — see status-palette note above).
  static const Color lightSuccessForeground = Color(0xFF1C1917);

  /// Stone-950 on emerald-400 (dark): ~9.1:1 ✅ WCAG AAA
  static const Color darkSuccessForeground = Color(0xFF1C1917);

  // Warning — Amber family
  static const Color lightWarning = Color(0xFFF59E0B); // amber-500
  static const Color darkWarning = Color(0xFFFBBF24); // amber-400
  /// Stone-950 on amber-500 (light): ~8.6:1 ✅ WCAG AAA
  static const Color lightWarningForeground = Color(0xFF1C1917); // stone-950
  /// Stone-950 on amber-400 (dark): ~9.8:1 ✅ WCAG AAA
  static const Color darkWarningForeground = Color(0xFF1C1917); // stone-950

  // Info — Sky family
  static const Color lightInfo = Color(0xFF0EA5E9); // sky-500
  static const Color darkInfo = Color(0xFF38BDF8); // sky-400
  /// Stone-950 on sky-500 (light): ~4.7:1 ✅ WCAG AA
  static const Color lightInfoForeground = Color(0xFF1C1917);

  /// Stone-950 on sky-400 (dark): ~8.9:1 ✅ WCAG AAA
  static const Color darkInfoForeground = Color(0xFF1C1917);

  // Error (status) — Rose family. Berbeda dari role `error` M3 di atas:
  // ini semantic status color untuk extension, bukan ColorScheme.error.
  static const Color lightStatusError = Color(0xFFF43F5E); // rose-500
  static const Color darkStatusError = Color(0xFFFB7185); // rose-400
  /// Stone-950 on rose-500 (light): 4.76:1 — passes WCAG AA.
  /// Previously white (3.67:1, fails AA — see status-palette note above).
  static const Color lightStatusErrorForeground = Color(0xFF1C1917);

  /// Stone-950 on rose-400 (dark): ~8.1:1 ✅ WCAG AAA
  static const Color darkStatusErrorForeground = Color(0xFF1C1917);
}
