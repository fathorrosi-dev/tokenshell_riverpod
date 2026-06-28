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

  /// 0.12 — pressed / splash overlay (e.g., ripple-equivalent for shadcn feel).
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
  /// switch thumbs, and as the root [ThemeData.hoverColor] overlay on accent surfaces.
  static const double disabledSurface = 0.5;

  // ── Semantic fills ───────────────────────────────────────────────────────────

  /// 0.15 — [ColorScheme.errorContainer] fill (semi-transparent destructive color).
  static const double errorContainer = 0.15;
}
