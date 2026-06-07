import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/utils/responsive_helper.dart';

/// [BuildContext] convenience extensions used throughout the app.
///
/// Import this file once per feature; it surfaces the most-used
/// theme / navigation / layout helpers without verbose chains.
extension AppContextX on BuildContext {
  // ── Theme shortcuts ──────────────────────────────────────────────────────────

  /// Access the resolved shadcn/ui color tokens for the current brightness.
  AppThemeColors get colors => AppThemeExtension.of(this).colors;

  /// Material 3 [ColorScheme] from the active [ThemeData].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Material 3 [TextTheme] from the active [ThemeData].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Active [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Whether the current brightness is dark.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Responsive shortcuts ─────────────────────────────────────────────────────

  /// Resolved [ScreenSizeClass] for this context.
  ScreenSizeClass get sizeClass => ResponsiveHelper.of(this);

  /// `true` when [sizeClass] == [ScreenSizeClass.compact].
  bool get isCompact => sizeClass == ScreenSizeClass.compact;

  /// `true` when [sizeClass] == [ScreenSizeClass.medium].
  bool get isMedium => sizeClass == ScreenSizeClass.medium;

  /// `true` when [sizeClass] == [ScreenSizeClass.expanded].
  bool get isExpanded => sizeClass == ScreenSizeClass.expanded;

  /// Logical screen width from the nearest [MediaQuery].
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Logical screen height from the nearest [MediaQuery].
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // ── Spacing shortcuts ─────────────────────────────────────────────────────────

  /// Horizontal page padding — adapts to size class.
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: ResponsiveHelper.resolve(
      this,
      compact: SpacingTokens.xl,
      medium: SpacingTokens.x3l,
      expanded: SpacingTokens.x4l,
    ),
    vertical: SpacingTokens.xl,
  );

  // ── Navigation shortcuts ─────────────────────────────────────────────────────

  /// Push a named route via go_router.
  void pushNamed(String name, {Map<String, String> params = const {}}) =>
      GoRouter.of(this).pushNamed(name, pathParameters: params);

  /// Navigate (replace) to a named route via go_router.
  void goNamed(String name, {Map<String, String> params = const {}}) =>
      GoRouter.of(this).goNamed(name, pathParameters: params);

  /// Pop the current route.
  void pop<T>([T? result]) => GoRouter.of(this).pop(result);
}
