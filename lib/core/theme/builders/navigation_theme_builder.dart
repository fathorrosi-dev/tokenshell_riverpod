import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds [ThemeData] sub-themes for top-level navigation chrome
/// (app bar, bottom navigation bar, navigation rail, tab bar, drawer).
///
/// See `button_theme_builder.dart` for the rationale behind splitting
/// `app_theme.dart` by widget family.
///
/// Wave 1 M3 core refactor: drawer corners moved to the M3 large (16dp)
/// shape category (spec container shape 0,16,16,0 — end corners only),
/// tonal elevation restored (app bar scrolled state level 2 = 3dp, modal
/// drawer level 1 = 1dp; the shadcn-era `surfaceTintColor`/`shadowColor`
/// transparent overrides removed so elevation reads from `surfaceTint`),
/// and the tab bar's `NoSplash` + accent hover/focus overrides removed in
/// favor of the M3 state layers and ripple that `app_theme.dart` now
/// renders by default.
abstract final class NavigationThemeBuilder {
  static AppBarTheme appBar(
    AppThemeColors colors,
    TextTheme textTheme,
    SystemUiOverlayStyle systemOverlayStyle,
  ) {
    return AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.foreground,
      // M3 top app bar: resting level 0, elevation on scroll level 2 (3dp).
      elevation: 0,
      scrolledUnderElevation: 3,
      systemOverlayStyle: systemOverlayStyle,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colors.foreground,
        fontWeight: TypographyTokens.weightSemiBold,
      ),
      iconTheme: IconThemeData(
        color: colors.foreground,
        size: IconSizeTokens.md,
      ),
      actionsIconTheme: IconThemeData(
        color: colors.foreground,
        size: IconSizeTokens.md,
      ),
      centerTitle: false,
    );
  }

  static NavigationBarThemeData navigationBar(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return NavigationBarThemeData(
      backgroundColor: colors.background,
      // M3 navigation bar: elevation level 0 (no shadow/tint needed, and the
      // previous transparent overrides are removed so nothing re-suppresses
      // tonal elevation for the levels that do use it).
      elevation: 0,
      indicatorColor: colors.accent,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: colors.accentForeground,
            size: IconSizeTokens.lg,
          );
        }
        return IconThemeData(
          color: colors.mutedForeground,
          size: IconSizeTokens.lg,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelSmall?.copyWith(
            color: colors.foreground,
            fontWeight: TypographyTokens.weightSemiBold,
          );
        }
        return textTheme.labelSmall?.copyWith(color: colors.mutedForeground);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static NavigationRailThemeData navigationRail(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return NavigationRailThemeData(
      backgroundColor: colors.background,
      elevation: 0,
      indicatorColor: colors.accent,
      // IconSizeTokens.lg (22 px) matches the NavigationBar icon size and the
      // explicit intent captured in the comment that was in _RailShell ("FIXED:
      // was `size: 22` raw literal — use IconSizeTokens.lg"). The previous
      // value here was IconSizeTokens.md (20 px), which diverged from _RailShell
      // and from NavigationBarThemeData (both 22 px). Unified to .lg so
      // NavigationThemeBuilder is authoritative and _RailShell no longer needs
      // to override these props at the widget level.
      selectedIconTheme: IconThemeData(
        color: colors.accentForeground,
        size: IconSizeTokens.lg,
      ),
      unselectedIconTheme: IconThemeData(
        color: colors.mutedForeground,
        size: IconSizeTokens.lg,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colors.foreground,
        fontWeight: TypographyTokens.weightSemiBold,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colors.mutedForeground,
      ),
    );
  }

  static TabBarThemeData tabBar(AppThemeColors colors, TextTheme textTheme) {
    return TabBarThemeData(
      labelColor: colors.foreground,
      unselectedLabelColor: colors.mutedForeground,
      labelStyle: textTheme.labelLarge?.copyWith(
        fontWeight: TypographyTokens.weightSemiBold,
      ),
      unselectedLabelStyle: textTheme.labelLarge?.copyWith(
        fontWeight: TypographyTokens.weightRegular,
      ),
      dividerColor: colors.border,
      dividerHeight: BorderWidthTokens.sm,
      indicatorColor: colors.primary,
      indicatorSize: TabBarIndicatorSize.label,
    );
  }

  static DrawerThemeData drawer(AppThemeColors colors) {
    return DrawerThemeData(
      backgroundColor: colors.background,
      // M3 modal navigation drawer: elevation level 1 (1dp).
      elevation: 1,
      // M3 drawer container shape: 0,16,16,0 dp — the two end (far) corners
      // use the large (16dp) category; the near edge stays square.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(RadiusTokens.large),
          bottomRight: Radius.circular(RadiusTokens.large),
        ),
      ),
    );
  }
}
