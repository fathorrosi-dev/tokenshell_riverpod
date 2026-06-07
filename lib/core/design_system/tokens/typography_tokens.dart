import 'package:flutter/painting.dart';

/// Typography tokens derived from the shadcn/ui typographic system.
///
/// Font family: Geist (with system sans-serif fallback).
/// Letter spacing is intentionally tighter than Material 3 defaults
/// to match the shadcn/ui visual feel.
abstract final class TypographyTokens {
  // ── Font families ─────────────────────────────────────────────────────────────

  static const String fontFamily = 'Geist';
  static const List<String> fontFamilyFallback = ['sans-serif'];

  // ── Font sizes (sp) ───────────────────────────────────────────────────────────

  static const double sizeXs = 12; // xs
  static const double sizeSm = 14; // sm
  static const double sizeMd = 16; // base
  static const double sizeLg = 18; // lg
  static const double sizeXl = 20; // xl
  static const double size2xl = 24; // 2xl
  static const double size3xl = 30; // 3xl
  static const double size4xl = 36; // 4xl
  static const double size5xl = 48; // 5xl
  static const double size6xl = 60; // 6xl

  // ── Font weights ──────────────────────────────────────────────────────────────

  static const FontWeight weightThin = FontWeight.w100;
  static const FontWeight weightExtraLight = FontWeight.w200;
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  // ── Letter spacing — shadcn/ui uses a slightly tight feel ────────────────────

  /// -0.8px: use on large display text.
  static const double trackingTighter = -0.8;

  /// -0.4px: use on headings.
  static const double trackingTight = -0.4;

  /// 0.0px: normal tracking for body text.
  static const double trackingNormal = 0;

  /// +0.4px: use on labels and overlines.
  static const double trackingWide = 0.4;

  /// +0.8px: use on all-caps labels.
  static const double trackingWider = 0.8;

  // ── Line heights (multiplier of font size) ────────────────────────────────────

  /// 1.0 — tight single line.
  static const double leadingNone = 1;

  /// 1.25 — tight headings.
  static const double leadingTight = 1.25;

  /// 1.375 — snug headings.
  static const double leadingSnug = 1.375;

  /// 1.5 — normal body.
  static const double leadingNormal = 1.5;

  /// 1.625 — relaxed body.
  static const double leadingRelaxed = 1.625;

  /// 2.0 — loose / spacious.
  static const double leadingLoose = 2;
}
