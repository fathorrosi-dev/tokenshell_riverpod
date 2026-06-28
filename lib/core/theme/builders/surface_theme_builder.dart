import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds [ThemeData] sub-themes for surface/container widgets — things
/// that hold other content rather than being directly interactive
/// themselves (card, divider, dialog, list tile, popup menu, bottom
/// sheet, tooltip).
///
/// See `button_theme_builder.dart` for the rationale behind splitting
/// `app_theme.dart` by widget family — every value here is unchanged from
/// the pre-split implementation.
abstract final class SurfaceThemeBuilder {
  static CardThemeData card(AppThemeColors colors) {
    return CardThemeData(
      color: colors.card,
      shadowColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        side: BorderSide(color: colors.border),
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
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        side: BorderSide(color: colors.border),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
      ),
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
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        side: BorderSide(color: colors.border),
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
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      modalBackgroundColor: colors.card,
      modalElevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.xl),
        ),
      ),
      dragHandleColor: colors.mutedForeground,
      // 32 × 4 matches the shadcn/ui drag handle pill proportion.
      dragHandleSize: const Size(32, 4),
      showDragHandle: true,
    );
  }

  static TooltipThemeData tooltip(AppThemeColors colors, TextTheme textTheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.popover,
        border: Border.all(
          color: colors.border,
        ),
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
        boxShadow: ShadowTokens.sm,
      ),
      textStyle: textTheme.bodySmall?.copyWith(
        color: colors.popoverForeground,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.sm,
      ),
      waitDuration: DurationTokens.tooltipWait,
    );
  }
}
