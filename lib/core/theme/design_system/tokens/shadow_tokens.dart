import 'package:flutter/material.dart';

/// Box-shadow tokens for a subtle, low-contrast elevation system.
///
/// All shadow colors use semi-transparent black; no colored shadows.
/// Each tier is [static const] and can be used directly in [BoxDecoration].
abstract final class ShadowTokens {
  /// No shadow — completely flat.
  static const List<BoxShadow> none = [];

  /// Extra-small shadow — barely perceptible lift.
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A000000), // black 4 %
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Small shadow — for input fields and subtle cards.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 4,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000), // black 4 %
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Medium shadow — default for cards, dropdowns, and popovers.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000), // black 8 %
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 3,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];

  /// Large shadow — for modals and floating overlays.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000), // black 10 %
      blurRadius: 16,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 6,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  /// Extra-large shadow — for prominent panels.
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1A000000), // black 10 %
      blurRadius: 24,
      spreadRadius: -8,
      offset: Offset(0, 20),
    ),
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  /// 2xl shadow — maximum depth, use sparingly.
  static const List<BoxShadow> x2l = [
    BoxShadow(
      color: Color(0x26000000), // black 15 %
      blurRadius: 48,
      spreadRadius: -12,
      offset: Offset(0, 25),
    ),
  ];

  /// Resolves [shadow] for the given [brightness].
  ///
  /// Every tier above is calibrated as semi-transparent black, tuned for
  /// legibility against light surfaces. In dark mode that same black is
  /// barely distinguishable from typical dark-mode surface colors (e.g.
  /// `darkSurfaceContainerLow`/`darkSurfaceContainerHigh` #1B1B1B/#2B2B2B
  /// sitting on `darkSurface` #131313) — a production-readiness audit
  /// (01 Jul 2026) found the elevation cue effectively disappears for
  /// every dark-mode session.
  /// Rather than hand-tune a second, parallel dark-mode shadow palette
  /// (twice the tokens to keep in sync), this boosts each tier's alpha
  /// for [Brightness.dark] so the same shape/blur/offset stays visually
  /// perceptible against dark surfaces. [Brightness.light] returns
  /// [shadow] unchanged — zero behavior change for the common case.
  static List<BoxShadow> resolve(
    Brightness brightness,
    List<BoxShadow> shadow,
  ) {
    if (brightness == Brightness.light || shadow.isEmpty) return shadow;
    return [
      for (final s in shadow)
        BoxShadow(
          color: s.color.withValues(alpha: (s.color.a * 2.2).clamp(0.0, 1.0)),
          blurRadius: s.blurRadius,
          spreadRadius: s.spreadRadius,
          offset: s.offset,
          blurStyle: s.blurStyle,
        ),
    ];
  }
}
