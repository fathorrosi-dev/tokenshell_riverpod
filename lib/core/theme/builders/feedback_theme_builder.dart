import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds [ThemeData] sub-themes for smaller interactive/feedback
/// controls — chip, switch, checkbox, radio, snack bar, progress
/// indicator, slider, badge, expansion tile, scrollbar, menu button.
///
/// These don't share a single Material category the way buttons or
/// navigation chrome do, but they're all "small, stateful, give the user
/// feedback" widgets — grouping them here keeps `app_theme.dart` from
/// having a sixth near-empty builder file for each one individually.
///
/// See `button_theme_builder.dart` for the rationale behind splitting
/// `app_theme.dart` by widget family.
///
/// Wave 1 M3 core refactor: shapes moved onto the M3 per-component shape
/// categories (chips=small 8dp, checkbox/snackbar/menu=extraSmall 4dp,
/// scrollbar=full), snackbar elevation restored to the M3 6dp default, and
/// the legacy manual hover/focus overrides removed in favor of the M3 state
/// layers and ripple that `app_theme.dart` now renders by default.
abstract final class FeedbackThemeBuilder {
  static ChipThemeData chip(ColorScheme colors, TextTheme textTheme) {
    return ChipThemeData(
      backgroundColor: colors.secondaryContainer,
      selectedColor: colors.primary,
      disabledColor: colors.surfaceContainerHighest,
      deleteIconColor: colors.onSurfaceVariant,
      labelStyle: textTheme.labelMedium?.copyWith(
        color: colors.onSecondaryContainer,
      ),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: colors.onPrimary,
      ),
      // M3 outlined-chip border uses the outline role, not outlineVariant:
      // outlineVariant is for decorative dividers and fails the 3:1
      // non-text contrast bar against the secondaryContainer fill here,
      // while outline (~3.2:1 in light mode) is built for exactly this.
      side: BorderSide(color: colors.outline),
      // M3 chip shape category: small (8dp).
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.small),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.xs,
      ),
      elevation: 0,
      pressElevation: 0,
    );
  }

  static SwitchThemeData switchTheme(ColorScheme colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurfaceVariant.withValues(
            alpha: OpacityTokens.disabledSurface,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return colors.onPrimary;
        }
        return colors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.surfaceContainerHighest;
        }
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.outline;
      }),
      // Unselected track is already the outline-colored solid, so an
      // additional M3 outline border is intentionally suppressed.
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  static CheckboxThemeData checkbox(ColorScheme colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.surfaceContainerHighest;
        }
        if (states.contains(WidgetState.selected)) return colors.primary;
        // Unselected: transparent fill. M3 hover/focus/pressed state layers
        // (onSurface) render automatically — no manual tint needed.
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(colors.onPrimary),
      side: WidgetStateBorderSide.resolveWith((states) {
        // selected → primary (solid fill matches the border — clear checked state).
        if (states.contains(WidgetState.selected)) {
          return BorderSide(color: colors.primary, width: BorderWidthTokens.md);
        }
        // disabled → muted surface tier (recedes, signals non-interactable).
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colors.surfaceContainerHighest,
            width: BorderWidthTokens.md,
          );
        }
        // focused → primary at 2 px width. Mirrors the focused input border
        // treatment (focusedBorder uses primary + BorderWidthTokens.lg) so
        // keyboard focus on a checkbox looks consistent with focus on any
        // TextField. M3 has no dedicated "focus ring" role — primary is
        // this app's deliberate stand-in (see theme_constants.dart).
        // Documented exception to the M3 default: the framework's focus
        // state layer already renders, but an explicit 2px border keeps
        // focus unmistakable for keyboard/tab users.
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colors.primary, width: BorderWidthTokens.lg);
        }
        // hovered → primary border at normal width. More prominent than the
        // outline color at rest, signalling the control is about to be clicked.
        if (states.contains(WidgetState.hovered)) {
          return BorderSide(color: colors.primary, width: BorderWidthTokens.md);
        }
        // unselected (default) → outline role. Using the same color as
        // TextField borders makes unchecked checkboxes visually consistent
        // with the rest of the form — lighter weight so they don't compete
        // for attention in a list of fields.
        return BorderSide(color: colors.outline, width: BorderWidthTokens.md);
      }),
      shape: RoundedRectangleBorder(
        // M3 checkbox is a rounded square (spec container shape 2dp; Flutter
        // M3 default radius 2.0). Our shape scale has no 2dp token —
        // extraSmall (4dp) is the nearest category.
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
    );
  }

  static RadioThemeData radio(ColorScheme colors) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.onSurfaceVariant.withValues(
            alpha: OpacityTokens.disabledContent,
          );
        }
        if (states.contains(WidgetState.selected)) return colors.primary;
        // Unselected: transparent fill. M3 hover/focus/pressed state layers
        // (onSurface) render automatically — no manual tint needed.
        return Colors.transparent;
      }),
    );
  }

  static SnackBarThemeData snackBar(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return SnackBarThemeData(
      backgroundColor: colors.onSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.surface,
      ),
      // SnackBar background is colors.onSurface (dark-toned in light mode,
      // light-toned in dark mode — see ColorTokens.lightOnSurface /
      // darkOnSurface). The action text must contrast against that
      // background:
      //   • Light mode: onSurface is the dark tone → use onPrimary (white
      //     in light mode) so action text is readable on the dark snackbar.
      //   • Dark mode: onSurface is the light tone → use onPrimary (dark in
      //     dark mode) so action text is readable on the light snackbar.
      // onPrimary is always the inverse of primary, making it the natural
      // choice regardless of brightness — explicit and predictable.
      actionTextColor: colors.onPrimary,
      shape: RoundedRectangleBorder(
        // M3 snackbar shape category: extraSmall (4dp).
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
      behavior: SnackBarBehavior.floating,
      // M3 snackbar elevation is 6dp (default). In the monochrome scheme
      // the surfaceTint at 6dp is ~indistinguishable from the container
      // color, so no explicit override is needed here.
    );
  }

  static ProgressIndicatorThemeData progressIndicator(ColorScheme colors) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.surfaceContainerHighest,
      circularTrackColor: colors.surfaceContainerHighest,
      linearMinHeight: 4,
    );
  }

  /// Flat 4px track, solid thumb; M3 hover/focus/pressed overlay is left at
  /// the framework default so the slider shows its state layer.
  static SliderThemeData slider(ColorScheme colors, TextTheme textTheme) {
    return SliderThemeData(
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.surfaceContainerHighest,
      disabledActiveTrackColor: colors.primary.withValues(
        alpha: OpacityTokens.disabledSurface,
      ),
      disabledInactiveTrackColor: colors.surfaceContainerHighest,
      thumbColor: colors.primary,
      disabledThumbColor: colors.primary.withValues(
        alpha: OpacityTokens.disabledSurface,
      ),
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      valueIndicatorShape: const DropSliderValueIndicatorShape(),
      valueIndicatorColor: colors.surfaceContainerHigh,
      valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(
        color: colors.onSurface,
      ),
      showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    );
  }

  /// Notification badges follow the primary color. smallSize is a dot-only badge.
  static BadgeThemeData badge(ColorScheme colors, TextTheme textTheme) {
    return BadgeThemeData(
      backgroundColor: colors.primary,
      textColor: colors.onPrimary,
      smallSize: 6,
      largeSize: 16,
      textStyle: textTheme.labelSmall,
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.sm),
    );
  }

  /// Used for accordion / settings sections. Border-bottom only, transparent bg.
  static ExpansionTileThemeData expansionTile(ColorScheme colors) {
    return ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: colors.onSurfaceVariant,
      collapsedIconColor: colors.onSurfaceVariant,
      textColor: colors.onSurface,
      collapsedTextColor: colors.onSurface,
      tilePadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.xs,
      ),
      childrenPadding: const EdgeInsets.only(bottom: SpacingTokens.md),
      // Border-bottom only — a deliberately minimal divider treatment
      // rather than a fully bordered container.
      shape: Border(bottom: BorderSide(color: colors.outlineVariant)),
      collapsedShape: Border(bottom: BorderSide(color: colors.outlineVariant)),
    );
  }

  /// Minimal pill scrollbar — visible only on hover/drag, transparent track.
  static ScrollbarThemeData scrollbar(ColorScheme colors) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged) ||
            states.contains(WidgetState.hovered)) {
          // More visible when interacting.
          return colors.onSurfaceVariant;
        }
        // Subtle at rest — deliberately minimal.
        return colors.outlineVariant;
      }),
      trackColor: const WidgetStatePropertyAll(Colors.transparent),
      trackBorderColor: const WidgetStatePropertyAll(Colors.transparent),
      // Fully rounded pill shape.
      radius: const Radius.circular(RadiusTokens.full),
      // 6 px is a deliberate composite value — no spacing token maps to scrollbar thickness.
      thickness: const WidgetStatePropertyAll(6),
      crossAxisMargin: SpacingTokens.xs,
      mainAxisMargin: SpacingTokens.xs,
    );
  }

  /// MenuAnchor / SubmenuButton items. Transparent rest state; hover/focus/
  /// pressed feedback comes from the M3 state layer and ripple.
  static MenuButtonThemeData menuButton(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.onSurface.withValues(
              alpha: OpacityTokens.disabledContent,
            );
          }
          return colors.onSurface;
        }),
        textStyle: WidgetStatePropertyAll(
          textTheme.bodyMedium?.copyWith(
            fontWeight: TypographyTokens.weightRegular,
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: SpacingTokens.lg,
            vertical: SpacingTokens.md,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            // M3 menu container/items use the extraSmall (4dp) shape.
            borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
          ),
        ),
      ),
    );
  }
}
