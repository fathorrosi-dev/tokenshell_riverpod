import 'package:flutter/material.dart';

/// Animation and timing duration tokens.
///
/// All values are [const Duration] instances — safe to embed in [ThemeData]
/// and [AnimatedTheme] without allocating new objects at runtime.
abstract final class DurationTokens {
  /// 100 ms — micro-interactions (icon swaps, fast badge transitions).
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// 150 ms — fast transitions (button state changes, chip selection).
  static const Duration fast = Duration(milliseconds: 150);

  /// 250 ms — standard UI transitions (page entry, modal fade).
  static const Duration normal = Duration(milliseconds: 250);

  /// 350 ms — slower transitions (large surface reveals, drawer open).
  static const Duration slow = Duration(milliseconds: 350);

  /// 500 ms — tooltip initial delay before the overlay appears.
  static const Duration tooltipWait = Duration(milliseconds: 500);
}
