import 'package:flutter/material.dart';

/// Opacity tokens for interactive overlays and disabled states.
///
/// All values are a fraction in [0.0, 1.0] — pass directly to
/// [Color.withValues(alpha: ...)] instead of using raw literals.
///
/// Naming follows two axes:
///   - **Interaction overlays** (hover, pressed) — applied on top of a base color.
///   - **Disabled states** (content, surface) — reduce opacity of existing colors.
abstract final class OpacityTokens {
  // ── Interaction overlays ─────────────────────────────────────────────────────

  /// 0.04 — barely perceptible overlay; for subtle hover on already-colored surfaces.
  static const double hoverSubtle = 0.04;

  /// 0.08 — standard hover overlay (e.g., tint on primary button background on hover).
  static const double hover = 0.08;

  /// 0.12 — pressed / splash overlay (M3 pressed state-layer opacity).
  static const double pressed = 0.12;

  /// 0.12 — root [ThemeData.focusColor] overlay alpha.
  ///
  /// Intentionally the same numeric value as [pressed] but a separate constant
  /// so the two semantics — "button was pressed" and "element has keyboard
  /// focus" — can be tuned independently in future design iterations without
  /// an accidental cross-coupling. Design systems commonly raise focus overlays
  /// (0.15–0.20) while keeping pressed more subtle (0.10–0.12) as the
  /// product matures; having a single constant prevented that divergence.
  ///
  /// Previously [AppTheme] referenced [pressed] for focusColor, conflating
  /// the two signals. Now [AppTheme] uses this token instead.
  static const double focusOverlay = 0.12;

  // ── Disabled states ──────────────────────────────────────────────────────────

  /// 0.4 — disabled foreground (text and icon elements when a component is disabled).
  ///
  /// Used for outlined/text button foreground, radio thumb, and similar ink elements.
  static const double disabledContent = 0.4;

  /// 0.5 — disabled surface (background, border, or track when a component is disabled).
  ///
  /// Used for elevated button background/foreground in disabled state, input borders,
  /// switch thumbs, and as the root [ThemeData.hoverColor] overlay on primary surfaces.
  static const double disabledSurface = 0.5;

  // ── Semantic fills ───────────────────────────────────────────────────────────

  /// 0.15 — [ColorScheme.errorContainer] fill (semi-transparent destructive color).
  static const double errorContainer = 0.15;

  /// 0.15 — generic semi-transparent "container" fill for M3 roles that tint
  /// a base color rather than defining a dedicated solid one (e.g.
  /// [ColorScheme.tertiaryContainer]).
  ///
  /// Same numeric value as [errorContainer] — both express the same M3
  /// "*Container" role convention (a light tint of the paired base color)
  /// — kept as separate named constants so `error` and `tertiary` container
  /// intensity can diverge later without an accidental cross-coupling,
  /// same reasoning as [focusOverlay] vs [pressed] above. Previously
  /// [ThemeConstants.tertiaryContainer] hardcoded this as a raw `0.15`
  /// literal, the one gap in an otherwise fully token-driven file.
  static const double containerTint = 0.15;

  // ── Borders & dividers ───────────────────────────────────────────────────────

  /// 0.5 — [ColorScheme.outlineVariant] fill (half-opacity border, for
  /// decorative dividers / lighter separators, as opposed to full-weight
  /// [ColorScheme.outline] component borders).
  ///
  /// Same numeric value as [disabledSurface] but intentionally a separate
  /// constant — one expresses "this element is disabled," the other
  /// expresses "this divider is meant to be visually lighter than a real
  /// border," and conflating the two would make future adjustments to
  /// either semantic accidentally affect the other. Previously
  /// [ThemeConstants.outlineVariant] hardcoded this as a raw `0.5` literal.
  static const double outlineVariant = 0.5;
}
