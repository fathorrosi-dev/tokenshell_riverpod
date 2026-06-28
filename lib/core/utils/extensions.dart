import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
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

  // ── Responsive scale ──────────────────────────────────────────────────────────

  /// Linear scale multiplier for the current [ScreenSizeClass].
  ///
  /// compact = 1.0 · medium = 1.1 · expanded = 1.2
  ///
  /// Use this to opt any custom measurement (icon size, border radius,
  /// custom font size) into the same responsive scale as [spacing]:
  /// ```dart
  /// Icon(icon, size: IconSizeTokens.lg * context.scale)
  /// BorderRadius.circular(RadiusTokens.lg * context.scale)
  /// ```
  double get scale => AppSpacing.scaleFor(sizeClass);

  /// Scale-aware spacing tokens for the current [ScreenSizeClass].
  ///
  /// Prefer this over [SpacingTokens] inside widget `build()` methods.
  /// [SpacingTokens] remains the right choice for `const` contexts —
  /// const constructors, default parameters, [ThemeData] configuration.
  ///
  /// ## Allocation note
  ///
  /// Returns one of [AppSpacing]'s three cached breakpoint instances via
  /// [AppSpacing.forSizeClass] — zero heap allocation per call. (Earlier
  /// versions of this getter called the `AppSpacing(sizeClass)` constructor
  /// directly, silently bypassing that cache on every single call; the
  /// constructor is now private specifically to prevent that regression
  /// from reappearing.)
  ///
  /// Assigning to a local once per `build()` is still good style — it
  /// reads cleaner and avoids re-resolving [sizeClass] — but is no longer
  /// a correctness or performance concern either way:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final spacing = context.spacing;
  ///   return Padding(
  ///     padding: EdgeInsets.symmetric(
  ///       horizontal: spacing.xl,
  ///       vertical:   spacing.md,
  ///     ),
  ///   );
  /// }
  /// ```
  AppSpacing get spacing => AppSpacing.forSizeClass(sizeClass);

  // ── Accessibility ─────────────────────────────────────────────────────────────

  /// Whether the user has requested reduced motion at the OS level.
  ///
  /// Reads [MediaQuery.disableAnimationsOf] — the same flag Flutter's own
  /// animations respect ("Reduce Motion" on iOS / "Remove Animations" on
  /// Android). Always consume durations via [durations] rather than
  /// [DurationTokens] directly so this setting is honoured automatically.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Motion-aware duration tokens.
  ///
  /// Returns [Duration.zero] for all animation durations when [reduceMotion]
  /// is `true`, making every animated widget skip its transition silently.
  ///
  /// ```dart
  /// AnimatedOpacity(
  ///   duration: context.durations.fast,
  ///   opacity: visible ? 1 : 0,
  ///   child: child,
  /// )
  /// ```
  AppDurations get durations => AppDurations.forReduceMotion(reduceMotion: reduceMotion);

  // ── Spacing shortcuts ─────────────────────────────────────────────────────────

  /// Horizontal page padding — uses [spacing] so it scales with size class.
  ///
  /// compact : xl  (16 px base)
  /// medium  : x3l (24 px × 1.1 = 26.4 px)
  /// expanded: x4l (32 px × 1.2 = 38.4 px)
  ///
  /// The per-breakpoint token jump handles the coarse layout shift;
  /// the scale handles the fine-grained density increase within each class.
  ///
  /// ## Implementation note
  ///
  /// `spacing` is called once and assigned to `s` before the switch so
  /// that both the `horizontal` and `vertical` reads share the same
  /// [AppSpacing] instance. Splitting across two `context.spacing` calls
  /// (the previous approach) allocated two separate instances unnecessarily.
  EdgeInsets get pagePadding {
    final s = spacing;
    return EdgeInsets.symmetric(
      horizontal: switch (sizeClass) {
        ScreenSizeClass.compact => s.xl,
        ScreenSizeClass.medium => s.x3l,
        ScreenSizeClass.expanded => s.x4l,
      },
      vertical: s.xl,
    );
  }

  // ── Navigation shortcuts ─────────────────────────────────────────────────────
  //
  // Named `*Route` / `popRoute` — deliberately NOT `pushNamed` / `goNamed` /
  // `pop`. go_router's own `GoRouterHelper` extension on [BuildContext]
  // already defines methods with those exact names. Two extensions
  // exposing the same method name on the same type is only safe as long
  // as nothing imports both in the same file and calls it via plain
  // `context.foo()` — the moment both are in scope, the call becomes an
  // ambiguous-extension compile error ("none are more specific"), which is
  // exactly what previously forced `app_router.dart` to call
  // `GoRouterHelper(context).goNamed(...)` explicitly instead of the
  // natural `context.goNamed(...)` used everywhere else.
  //
  // Prefixing these with `Route` removes the collision with go_router's
  // *current* API entirely, and lowers the odds of colliding with
  // whatever methods go_router adds in future versions too — there's no
  // need to memorize go_router's vocabulary to stay safe.

  /// Push a named route via go_router.
  void pushNamedRoute(
    String name, {
    Map<String, String> params = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => GoRouter.of(this).pushNamed(
    name,
    pathParameters: params,
    queryParameters: queryParameters,
    extra: extra,
  );

  /// Navigate (replace) to a named route via go_router.
  void goNamedRoute(
    String name, {
    Map<String, String> params = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => GoRouter.of(this).goNamed(
    name,
    pathParameters: params,
    queryParameters: queryParameters,
    extra: extra,
  );

  /// Pop the current route.
  void popRoute<T>([T? result]) => GoRouter.of(this).pop(result);
}

// ── String extensions ─────────────────────────────────────────────────────────

extension StringX on String {
  /// Returns a copy of this string with the first character uppercased.
  ///
  /// Extracted from PostCard into a reusable extension so any widget can
  /// capitalise display text without duplicating the logic.
  ///
  /// Examples:
  /// ```dart
  /// 'hello world'.capitalised  // → 'Hello world'
  /// ''.capitalised             // → ''
  /// ```
  String get capitalised => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
