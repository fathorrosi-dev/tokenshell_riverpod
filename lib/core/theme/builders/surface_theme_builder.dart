import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds [ThemeData] sub-themes for surface/container widgets — things
/// that hold other content rather than being directly interactive
/// themselves (card, divider, dialog, list tile, popup menu, bottom
/// sheet, tooltip).
///
/// See `button_theme_builder.dart` for the rationale behind splitting
/// `app_theme.dart` by widget family.
///
/// Wave 1 M3 core refactor: shapes moved onto the M3 per-component shape
/// categories (card=medium 12dp, dialog/bottom-sheet=extraLarge 28dp,
/// popup menu/tooltip=extraSmall 4dp, list tile=rectangular), each
/// component's elevation/surfaceTint/shadow falls back to its M3 default,
/// the outline borders on card/dialog/menu are dropped (M3 elevated
/// surfaces are borderless), and [tooltip] now renders the genuine M3
/// "plain tooltip" — an inverseSurface fill with no border and no shadow —
/// instead of a bordered popover-style surface.
abstract final class SurfaceThemeBuilder {
  static CardThemeData card(ColorScheme colors) {
    return CardThemeData(
      color: colors.surfaceContainerLow,
      margin: EdgeInsets.zero,
      // M3 elevated card: medium (12dp) shape, no outline border. The M3
      // defaults (elevation 1 with colorScheme.shadow) provide the tonal lift.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.medium),
      ),
    );
  }

  static DividerThemeData divider(ColorScheme colors) {
    return DividerThemeData(
      color: colors.outlineVariant,
      thickness: BorderWidthTokens.sm,
      space: 0,
    );
  }

  static DialogThemeData dialog(ColorScheme colors, TextTheme textTheme) {
    return DialogThemeData(
      backgroundColor: colors.surfaceContainerHigh,
      // M3 dialog: extraLarge (28dp) shape, no outline border, elevation 6
      // (M3 default).
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.extraLarge),
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colors.onSurface,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
      ),
    );
  }

  static ListTileThemeData listTile(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return ListTileThemeData(
      tileColor: Colors.transparent,
      // M3-canonical selected-state role — matches the NavigationBar /
      // NavigationRail indicator treatment in navigation_theme_builder.dart.
      selectedTileColor: colors.secondaryContainer,
      textColor: colors.onSurface,
      selectedColor: colors.onSecondaryContainer,
      iconColor: colors.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.xs,
      ),
      // M3 Lists are rectangular — no container shape override (Flutter M3
      // ListTile default renders full-bleed edges).
      titleTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: TypographyTokens.weightMedium,
      ),
      subtitleTextStyle: textTheme.bodySmall?.copyWith(
        color: colors.onSurfaceVariant,
      ),
    );
  }

  static PopupMenuThemeData popupMenu(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return PopupMenuThemeData(
      color: colors.surfaceContainerHigh,
      // M3 menu: extraSmall (4dp) shape, no outline border, elevation 3 (M3
      // default).
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
      textStyle: textTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
      ),
      labelTextStyle: WidgetStatePropertyAll(
        textTheme.bodyMedium?.copyWith(color: colors.onSurface),
      ),
      menuPadding: const EdgeInsets.symmetric(vertical: SpacingTokens.xs),
    );
  }

  static BottomSheetThemeData bottomSheet(ColorScheme colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surfaceContainerLow,
      modalBackgroundColor: colors.surfaceContainerLow,
      // M3 modal bottom sheet: top corners extraLarge (28dp), elevation 1 (M3
      // default).
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.extraLarge),
        ),
      ),
      dragHandleColor: colors.onSurfaceVariant,
      // 32 × 4 matches the M3 drag handle pill proportion.
      dragHandleSize: const Size(32, 4),
      showDragHandle: true,
    );
  }

  /// M3 "plain tooltip": a solid [ColorScheme.inverseSurface] fill with no
  /// border and no shadow (m3.material.io/components/tooltips). This
  /// replaced an earlier bordered, popover-colored, drop-shadowed treatment
  /// that was closer to a shadcn/ui-style overlay than the M3 spec — plain
  /// tooltips are meant to read as a small, flat, high-contrast label, not
  /// an elevated surface.
  static TooltipThemeData tooltip(ColorScheme colors, TextTheme textTheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        // M3 tooltip container shape: extraSmall (4dp).
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: colors.onInverseSurface),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.sm,
      ),
      waitDuration: DurationTokens.tooltipWait,
    );
  }
}
