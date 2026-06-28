import 'package:tokenshell_riverpod/core/theme/design_system/tokens/duration_tokens.dart';

/// Motion-aware duration values that respect the OS accessibility setting
/// for reduced motion.
///
/// Access via `context.durations` — never hardcode [Duration] literals in
/// animated widgets:
/// ```dart
/// AnimatedContainer(
///   duration: context.durations.normal,
///   curve: Curves.easeOut,
///   ...,
/// )
/// ```
///
/// When the user has enabled "Reduce Motion" (iOS) or "Remove Animations"
/// (Android) in their OS accessibility settings, [MediaQuery.disableAnimationsOf]
/// returns `true` and every animation duration is silently replaced with
/// [Duration.zero] — making all transitions instant without any code changes
/// in individual widgets.
///
/// [DurationTokens] remains available for contexts where [BuildContext] is
/// not accessible (e.g. [ThemeData] construction, Riverpod providers).
///
/// ## Allocation strategy (R7)
///
/// There are exactly two possible [AppDurations] instances: one where
/// reduce-motion is active and one where it is not. [forReduceMotion]
/// returns from a pool of two static instances created lazily on first use
/// and reused for the lifetime of the app — mirroring the pattern used by
/// [AppSpacing.forSizeClass].
///
/// [context.durations] therefore costs one [MediaQuery] bool read per call
/// with zero heap allocation. The previous public constructor allocated a
/// new object on every access.
enum AppDurations {
  _normal._(reduceMotion: false),
  _reduced._(reduceMotion: true);

  // Private constructor — all callers must go through [forReduceMotion].
  const AppDurations._({required bool reduceMotion}) : _reduceMotion = reduceMotion;

  /// Returns the cached [AppDurations] instance for the given [reduceMotion]
  /// flag. Only two instances ever exist, allocated once and reused for the
  /// lifetime of the app — same pattern as [AppSpacing.forSizeClass].
  static AppDurations forReduceMotion({required bool reduceMotion}) => reduceMotion ? _reduced : _normal;

  final bool _reduceMotion;

  /// Returns [Duration.zero] if [reduceMotion] is active, else [base].
  Duration _d(Duration base) => _reduceMotion ? Duration.zero : base;

  // ── Animation durations (zeroed on reduce-motion) ────────────────────────────

  /// 100 ms — micro-interactions (icon swaps, fast badge transitions).
  Duration get ultraFast => _d(DurationTokens.ultraFast);

  /// 150 ms — fast UI transitions (button state, chip selection).
  Duration get fast => _d(DurationTokens.fast);

  /// 250 ms — standard transitions (page entry, modal fade-in).
  Duration get normal => _d(DurationTokens.normal);

  /// 350 ms — slower transitions (drawer open, large surface reveals).
  Duration get slow => _d(DurationTokens.slow);

  // ── Non-animation delays (always honoured) ───────────────────────────────────

  /// 500 ms — tooltip initial delay before the overlay appears.
  ///
  /// NOT zeroed on reduce-motion: this is a pointer-rest delay, not an
  /// animation duration. Accessibility guidance targets the visual motion
  /// of the tooltip fade-in, not the timer that triggers it. Zeroing this
  /// would cause tooltips to flash immediately on every hover, which is
  /// worse UX for users who rely on them most.
  Duration get tooltipWait => DurationTokens.tooltipWait;

  // ── Diagnostic ───────────────────────────────────────────────────────────────

  /// Whether reduce-motion is currently active.
  ///
  /// Useful for conditionally swapping animated widgets for their static
  /// equivalents when [Duration.zero] alone is not enough:
  /// ```dart
  /// if (context.durations.isReduceMotion)
  ///   return const StaticHeroImage();
  /// return AnimatedHeroImage(duration: context.durations.normal);
  /// ```
  bool get isReduceMotion => _reduceMotion;
}
