import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
/// drawer level 1 = 1dp; `surfaceTintColor`/`shadowColor` read from the M3
/// defaults instead of being forced transparent), the tab bar's ripple/state
/// layers restored to the M3 defaults, and the NavigationBar / NavigationRail
/// selected indicator moved from a primary-based bridge onto M3's canonical
/// `secondaryContainer` / `onSecondaryContainer` roles.
abstract final class NavigationThemeBuilder {
  static AppBarTheme appBar(
    ColorScheme colors,
    TextTheme textTheme,
    SystemUiOverlayStyle systemOverlayStyle,
  ) {
    return AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      // M3 top app bar: resting level 0, elevation on scroll level 2 (3dp).
      elevation: 0,
      scrolledUnderElevation: 3,
      systemOverlayStyle: systemOverlayStyle,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: TypographyTokens.weightSemiBold,
      ),
      iconTheme: IconThemeData(
        color: colors.onSurface,
        size: IconSizeTokens.md,
      ),
      actionsIconTheme: IconThemeData(
        color: colors.onSurface,
        size: IconSizeTokens.md,
      ),
      centerTitle: false,
    );
  }

  static NavigationBarThemeData navigationBar(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return NavigationBarThemeData(
      backgroundColor: colors.surface,
      // M3 navigation bar: elevation level 0 (no shadow/tint needed).
      elevation: 0,
      // M3-canonical selected-state indicator role (matches Flutter's own
      // NavigationBar defaults) — see the class doc comment above.
      indicatorColor: colors.secondaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: colors.onSecondaryContainer,
            size: IconSizeTokens.lg,
          );
        }
        return IconThemeData(
          color: colors.onSurfaceVariant,
          size: IconSizeTokens.lg,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: TypographyTokens.weightSemiBold,
          );
        }
        return textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant);
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static NavigationRailThemeData navigationRail(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return NavigationRailThemeData(
      backgroundColor: colors.surface,
      elevation: 0,
      // M3-canonical selected-state indicator role — see the class doc
      // comment above.
      indicatorColor: colors.secondaryContainer,
      // IconSizeTokens.lg (22 px) matches the NavigationBar icon size and the
      // explicit intent captured in the comment that was in _RailShell ("FIXED:
      // was `size: 22` raw literal — use IconSizeTokens.lg"). The previous
      // value here was IconSizeTokens.md (20 px), which diverged from _RailShell
      // and from NavigationBarThemeData (both 22 px). Unified to .lg so
      // NavigationThemeBuilder is authoritative and _RailShell no longer needs
      // to override these props at the widget level.
      selectedIconTheme: IconThemeData(
        color: colors.onSecondaryContainer,
        size: IconSizeTokens.lg,
      ),
      unselectedIconTheme: IconThemeData(
        color: colors.onSurfaceVariant,
        size: IconSizeTokens.lg,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: TypographyTokens.weightSemiBold,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colors.onSurfaceVariant,
      ),
    );
  }

  static TabBarThemeData tabBar(ColorScheme colors, TextTheme textTheme) {
    return TabBarThemeData(
      labelColor: colors.onSurface,
      unselectedLabelColor: colors.onSurfaceVariant,
      labelStyle: textTheme.labelLarge?.copyWith(
        fontWeight: TypographyTokens.weightSemiBold,
      ),
      unselectedLabelStyle: textTheme.labelLarge?.copyWith(
        fontWeight: TypographyTokens.weightRegular,
      ),
      dividerColor: colors.outlineVariant,
      dividerHeight: BorderWidthTokens.sm,
      indicatorColor: colors.primary,
      indicatorSize: TabBarIndicatorSize.label,
    );
  }

  static DrawerThemeData drawer(ColorScheme colors) {
    return DrawerThemeData(
      backgroundColor: colors.surface,
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
