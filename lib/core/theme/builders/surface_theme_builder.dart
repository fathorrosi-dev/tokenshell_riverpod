import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
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
/// popup menu/tooltip=extraSmall 4dp, list tile=rectangular), the flat
/// shadcn-era elevation/surfaceTint/shadow overrides removed so each
/// component falls back to its M3 elevation default, and the outline
/// borders on card/dialog/menu dropped (M3 elevated surfaces are
/// borderless).
abstract final class SurfaceThemeBuilder {
  static CardThemeData card(AppThemeColors colors) {
    return CardThemeData(
      color: colors.card,
      margin: EdgeInsets.zero,
      // M3 elevated card: medium (12dp) shape, no outline border. The old
      // `elevation: 0` + transparent shadow are dropped — the M3 defaults
      // (elevation 1 with colorScheme.shadow) restore the tonal lift.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.medium),
      ),
    );
  }

  static DividerThemeData divider(AppThemeColors colors) {
    return DividerThemeData(
      color: colors.border,
      thickness: BorderWidthTokens.sm,
      space: 0,
    );
  }

  static DialogThemeData dialog(AppThemeColors colors, TextTheme textTheme) {
    return DialogThemeData(
      backgroundColor: colors.popover,
      // M3 dialog: extraLarge (28dp) shape, no outline border, elevation 6
      // (M3 default). The flat `elevation: 0` + transparent shadow/tint
      // overrides are dropped.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.extraLarge),
      ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colors.popoverForeground,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.popoverForeground,
      ),
    );
  }

  static ListTileThemeData listTile(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: colors.accent,
      textColor: colors.foreground,
      selectedColor: colors.accentForeground,
      iconColor: colors.mutedForeground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.xs,
      ),
      // M3 Lists are rectangular — no container shape override (Flutter M3
      // ListTile default renders full-bleed edges).
      titleTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.foreground,
        fontWeight: TypographyTokens.weightMedium,
      ),
      subtitleTextStyle: textTheme.bodySmall?.copyWith(
        color: colors.mutedForeground,
      ),
    );
  }

  static PopupMenuThemeData popupMenu(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return PopupMenuThemeData(
      color: colors.popover,
      // M3 menu: extraSmall (4dp) shape, no outline border, elevation 3 (M3
      // default). The flat `elevation: 0` + transparent shadow/tint are dropped.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
      textStyle: textTheme.bodyMedium?.copyWith(
        color: colors.popoverForeground,
      ),
      labelTextStyle: WidgetStatePropertyAll(
        textTheme.bodyMedium?.copyWith(color: colors.popoverForeground),
      ),
      menuPadding: const EdgeInsets.symmetric(vertical: SpacingTokens.xs),
    );
  }

  static BottomSheetThemeData bottomSheet(AppThemeColors colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.card,
      modalBackgroundColor: colors.card,
      // M3 modal bottom sheet: top corners extraLarge (28dp), elevation 1 (M3
      // default). The flat `elevation`/`modalElevation: 0` + transparent
      // shadow/tint overrides are dropped.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.extraLarge),
        ),
      ),
      dragHandleColor: colors.mutedForeground,
      // 32 × 4 matches the M3 drag handle pill proportion.
      dragHandleSize: const Size(32, 4),
      showDragHandle: true,
    );
  }

  static TooltipThemeData tooltip(
    AppThemeColors colors,
    TextTheme textTheme,
    Brightness brightness,
  ) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.popover,
        border: Border.all(color: colors.border),
        // M3 tooltip container shape: extraSmall (4dp).
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
        // Brightness-resolved so the shadow stays perceptible in dark
        // mode instead of blending into a near-black surface — see
        // [ShadowTokens.resolve] for the full rationale.
        boxShadow: ShadowTokens.resolve(brightness, ShadowTokens.sm),
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: colors.popoverForeground),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.sm,
      ),
      waitDuration: DurationTokens.tooltipWait,
    );
  }
}
