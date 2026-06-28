import 'package:flutter/foundation.dart';

import 'package:tokenshell_riverpod/core/theme/design_system/tokens/spacing_tokens.dart';
import 'package:tokenshell_riverpod/core/utils/responsive_helper.dart';

/// Scale-aware spacing values derived from [SpacingTokens].
///
/// Accessed via `context.spacing`:
/// ```dart
/// Padding(padding: EdgeInsets.all(context.spacing.md))
/// SizedBox(height: context.spacing.x4l)
/// ```
///
/// Mirrors the Wonderous app's `_Insets` approach — a single [scale]
/// multiplier is computed from [ScreenSizeClass] and applied uniformly
/// to every spacing value, so layouts expand proportionally on larger
/// screens without per-widget breakpoint checks.
///
/// [SpacingTokens] remains the source of truth and is safe to use in
/// `const` contexts (const constructors, default parameters, ThemeData).
/// Use [AppSpacing] inside `build()` for all spacing that should respond
/// to screen size.
///
/// ## Allocation strategy
///
/// [AppSpacing] is a class, not a namespace, because [ScreenSizeClass] only
/// has three variants. [forSizeClass] returns from a pool of three static
/// instances — one per breakpoint — that are created lazily on first use
/// and reused for the lifetime of the app.
///
/// [context.spacing] therefore costs only one [MediaQuery] width read per
/// call with zero heap allocation. Multiple calls to `context.spacing` within
/// the same `build()` method are safe and cheap; assigning to a local variable
/// is still good style but no longer a correctness concern.
@immutable
class AppSpacing {
  /// Creates spacing values scaled for the given [sizeClass].
  ///
  /// Private — [forSizeClass] is the only way to get an [AppSpacing]
  /// instance from outside this file. This used to be a public
  /// constructor, and [AppContextX.spacing] (`core/utils/extensions.dart`)
  /// called it directly on every access instead of going through the
  /// cache below, silently defeating the whole point of [forSizeClass].
  /// Making this private closes that hole at the type-system level instead
  /// of relying on doc comments and discipline.
  AppSpacing._(ScreenSizeClass sizeClass) : _scale = scaleFor(sizeClass);

  // ── Instance cache ─────────────────────────────────────────────────────────

  static final AppSpacing _compact = AppSpacing._(ScreenSizeClass.compact);
  static final AppSpacing _medium = AppSpacing._(ScreenSizeClass.medium);
  static final AppSpacing _expanded = AppSpacing._(ScreenSizeClass.expanded);

  /// Returns the cached [AppSpacing] instance for [sizeClass].
  ///
  /// The three breakpoint instances are created once (lazily, on first
  /// static access) and reused for the lifetime of the app — this is the
  /// *only* way to obtain an [AppSpacing], and it's what
  /// [AppContextX.spacing] actually uses under the hood.
  static AppSpacing forSizeClass(ScreenSizeClass sizeClass) =>
      switch (sizeClass) {
        ScreenSizeClass.compact => _compact,
        ScreenSizeClass.medium => _medium,
        ScreenSizeClass.expanded => _expanded,
      };

  final double _scale;

  // ── Scale mapping ─────────────────────────────────────────────────────────────

  /// Maps [ScreenSizeClass] → linear scale multiplier.
  ///
  /// compact  (< 600 px)   → 1.0  — base scale, no change.
  /// medium   (600–839 px) → 1.1  — +10 % for phone-landscape / small tablet.
  /// expanded (≥ 840 px)   → 1.2  — +20 % for tablet / desktop.
  ///
  /// Static so callers (e.g. [AppContextX.scale]) can use it without
  /// constructing an [AppSpacing] instance.
  static double scaleFor(ScreenSizeClass sizeClass) => switch (sizeClass) {
    ScreenSizeClass.compact => 1.0,
    ScreenSizeClass.medium => 1.1,
    ScreenSizeClass.expanded => 1.2,
  };

  // ── Raw scale ─────────────────────────────────────────────────────────────────

  /// The raw scale multiplier for this size class.
  ///
  /// Opt custom widgets into the same scale factor:
  /// ```dart
  /// Icon(icon, size: IconSizeTokens.md * context.spacing.scale)
  /// BorderRadius.circular(RadiusTokens.md * context.spacing.scale)
  /// ```
  double get scale => _scale;

  // ── Anchored values (never scale) ─────────────────────────────────────────────

  /// 0 px — always zero, regardless of size class.
  final double none = SpacingTokens.none;

  /// 1 px — hairline rule / single-pixel divider.
  ///
  /// Intentionally not scaled: a "1 px border" should remain 1 px
  /// on any screen; scaling it would make it 1.1 or 1.2 px and alias
  /// differently across devices.
  final double px = SpacingTokens.px;

  // ── Scaled values ─────────────────────────────────────────────────────────────
  //
  // Each value shows: base → medium (+10%) → expanded (+20%)
  //
  // `late final` — computed at most once per instance (lazy, zero alloc
  // on unused tokens).

  late final double xs = SpacingTokens.xs * _scale; //   2 → 2.2  → 2.4
  late final double sm = SpacingTokens.sm * _scale; //   4 → 4.4  → 4.8
  late final double md = SpacingTokens.md * _scale; //   8 → 8.8  → 9.6
  late final double lg = SpacingTokens.lg * _scale; //  12 → 13.2 → 14.4
  late final double xl = SpacingTokens.xl * _scale; //  16 → 17.6 → 19.2
  late final double x2l = SpacingTokens.x2l * _scale; //  20 → 22.0 → 24.0
  late final double x3l = SpacingTokens.x3l * _scale; //  24 → 26.4 → 28.8
  late final double x4l = SpacingTokens.x4l * _scale; //  32 → 35.2 → 38.4
  late final double x5l = SpacingTokens.x5l * _scale; //  40 → 44.0 → 48.0
  late final double x6l = SpacingTokens.x6l * _scale; //  48 → 52.8 → 57.6
  late final double x7l = SpacingTokens.x7l * _scale; //  56 → 61.6 → 67.2
  late final double x8l = SpacingTokens.x8l * _scale; //  64 → 70.4 → 76.8
  late final double x9l = SpacingTokens.x9l * _scale; //  80 → 88.0 → 96.0
  late final double x10l = SpacingTokens.x10l * _scale; //  96 → 105.6 → 115.2
  late final double x11l = SpacingTokens.x11l * _scale; // 112 → 123.2 → 134.4
  late final double x12l = SpacingTokens.x12l * _scale; // 128 → 140.8 → 153.6
  late final double x14l = SpacingTokens.x14l * _scale; // 160 → 176.0 → 192.0
  late final double x16l = SpacingTokens.x16l * _scale; // 192 → 211.2 → 230.4
  late final double x20l = SpacingTokens.x20l * _scale; // 256 → 281.6 → 307.2
  late final double x24l = SpacingTokens.x24l * _scale; // 320 → 352.0 → 384.0
  late final double x28l = SpacingTokens.x28l * _scale; // 384 → 422.4 → 460.8
  late final double x32l = SpacingTokens.x32l * _scale; // 448 → 492.8 → 537.6
  late final double x36l = SpacingTokens.x36l * _scale; // 512 → 563.2 → 614.4
}
