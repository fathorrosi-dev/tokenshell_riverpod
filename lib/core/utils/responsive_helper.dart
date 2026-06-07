import 'package:flutter/widgets.dart';

/// Canonical breakpoint size classes.
///
/// Based on Material 3 / adaptive layout guidelines:
/// - [compact]  → 0 – 599 px   (phone portrait)
/// - [medium]   → 600 – 839 px (phone landscape / small tablet)
/// - [expanded] → ≥ 840 px     (tablet / desktop)
///
/// NEVER use Platform.isAndroid, Platform.isIOS, or device-type strings
/// to drive layout decisions — use [ScreenSizeClass] exclusively.
enum ScreenSizeClass {
  compact,
  medium,
  expanded;

  /// Returns the [ScreenSizeClass] for the given [width] in logical pixels.
  static ScreenSizeClass fromWidth(double width) {
    if (width < 600) return ScreenSizeClass.compact;
    if (width < 840) return ScreenSizeClass.medium;
    return ScreenSizeClass.expanded;
  }
}

/// Static utility for resolving the current [ScreenSizeClass] from context.
abstract final class ResponsiveHelper {
  /// Returns the [ScreenSizeClass] for the nearest [MediaQuery] ancestor.
  static ScreenSizeClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ScreenSizeClass.fromWidth(width);
  }

  /// Returns `true` when the layout is [ScreenSizeClass.compact].
  static bool isCompact(BuildContext context) =>
      of(context) == ScreenSizeClass.compact;

  /// Returns `true` when the layout is [ScreenSizeClass.medium].
  static bool isMedium(BuildContext context) =>
      of(context) == ScreenSizeClass.medium;

  /// Returns `true` when the layout is [ScreenSizeClass.expanded].
  static bool isExpanded(BuildContext context) =>
      of(context) == ScreenSizeClass.expanded;

  /// Resolves a value by size class — useful for inline conditional layouts.
  ///
  /// ```dart
  /// final padding = ResponsiveHelper.resolve(
  ///   context,
  ///   compact: 16.0,
  ///   medium: 24.0,
  ///   expanded: 32.0,
  /// );
  /// ```
  static T resolve<T>(
    BuildContext context, {
    required T compact,
    required T medium,
    required T expanded,
  }) {
    return switch (of(context)) {
      ScreenSizeClass.compact => compact,
      ScreenSizeClass.medium => medium,
      ScreenSizeClass.expanded => expanded,
    };
  }
}
