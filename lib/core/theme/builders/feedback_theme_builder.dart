import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
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
/// the shadcn-era manual hover/focus overrides (built on the pre-Wave-0
/// NoSplash premise) removed in favor of the M3 state layers and ripple that
/// `app_theme.dart` now renders by default.
abstract final class FeedbackThemeBuilder {
  static ChipThemeData chip(AppThemeColors colors, TextTheme textTheme) {
    return ChipThemeData(
      backgroundColor: colors.secondary,
      selectedColor: colors.primary,
      disabledColor: colors.muted,
      deleteIconColor: colors.mutedForeground,
      labelStyle: textTheme.labelMedium?.copyWith(
        color: colors.secondaryForeground,
      ),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: colors.primaryForeground,
      ),
      // M3 outlined-chip border uses the outline role. `colors.border`
      // bridges to outlineVariant (decorative dividers) and fails the 3:1
      // non-text contrast bar on the secondaryContainer fill; `colors.input`
      // bridges to outline (~3.2:1 light) — a genuine M3 role, not a divider.
      side: BorderSide(color: colors.input),
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

  static SwitchThemeData switchTheme(AppThemeColors colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.mutedForeground.withValues(
            alpha: OpacityTokens.disabledSurface,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return colors.primaryForeground;
        }
        return colors.mutedForeground;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.muted;
        }
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.input;
      }),
      // Unselected track is already the outline-colored solid (colors.input),
      // so an additional M3 outline border is intentionally suppressed.
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  static CheckboxThemeData checkbox(AppThemeColors colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.muted;
        if (states.contains(WidgetState.selected)) return colors.primary;
        // Unselected: transparent fill. M3 hover/focus/pressed state layers
        // (onSurface) render automatically now that the ripple/state-layer
        // suppression is gone — no manual tint needed (and the old accent fill
        // would resolve to a near-black solid since accent bridges to primary).
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(colors.primaryForeground),
      side: WidgetStateBorderSide.resolveWith((states) {
        // selected → primary (solid fill matches the border — clear checked state).
        if (states.contains(WidgetState.selected)) {
          return BorderSide(color: colors.primary, width: BorderWidthTokens.md);
        }
        // disabled → muted (recedes, signals non-interactable).
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: colors.muted, width: BorderWidthTokens.md);
        }
        // focused → ring color at 2 px width. Mirrors the focused input border
        // treatment (focusedBorder uses ring + BorderWidthTokens.lg) so keyboard
        // focus on a checkbox looks consistent with focus on any TextField.
        // Documented exception to the M3 default: the framework's focus state
        // layer now renders (Wave 0 restored the interaction defaults), but an
        // explicit 2px border keeps focus unmistakable for keyboard/tab users.
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colors.ring, width: BorderWidthTokens.lg);
        }
        // hovered → primary border at normal width. More prominent than input
        // color at rest, signalling the control is about to be clicked.
        if (states.contains(WidgetState.hovered)) {
          return BorderSide(color: colors.primary, width: BorderWidthTokens.md);
        }
        // unselected (default) → input token (bridges to M3 outline).
        // Using the outline color (same as TextField) makes unchecked
        // checkboxes visually consistent with the rest of the form — lighter
        // weight so they don't compete for attention in a list of fields.
        // The previous value (colors.primary, near-black) made every unchecked
        // checkbox as visually heavy as a selected one.
        return BorderSide(color: colors.input, width: BorderWidthTokens.md);
      }),
      shape: RoundedRectangleBorder(
        // M3 checkbox is a rounded square (spec container shape 2dp; Flutter
        // M3 default radius 2.0). Our shape scale has no 2dp token —
        // extraSmall (4dp) is the nearest category.
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
    );
  }

  static RadioThemeData radio(AppThemeColors colors) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.mutedForeground.withValues(
            alpha: OpacityTokens.disabledContent,
          );
        }
        if (states.contains(WidgetState.selected)) return colors.primary;
        // Unselected: transparent fill. M3 hover/focus/pressed state layers
        // (onSurface) render automatically now that the interaction defaults
        // are restored — the old focused→ring / hovered→foreground branches
        // resolved to near-black solids (ring/foreground bridge to primary/
        // onSurface) and are no longer needed.
        return Colors.transparent;
      }),
    );
  }

  static SnackBarThemeData snackBar(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return SnackBarThemeData(
      backgroundColor: colors.foreground,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.background,
      ),
      // SnackBar background is colors.foreground (near-black in light, near-white
      // in dark). The action text must contrast against that background:
      //   • Light mode: foreground ≈ #030712 (near-black) → use primaryForeground
      //     (#FAFAFA, near-white) so action text is readable on the dark snackbar.
      //   • Dark mode:  foreground ≈ #F9FAFB (near-white) → use primaryForeground
      //     (#18181B, near-black) so action text is readable on the light snackbar.
      // primaryForeground is always the inverse of primary, making it the natural
      // choice regardless of brightness — explicit and predictable.
      actionTextColor: colors.primaryForeground,
      shape: RoundedRectangleBorder(
        // M3 snackbar shape category: extraSmall (4dp).
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
      ),
      behavior: SnackBarBehavior.floating,
      // M3 snackbar elevation is 6dp (default). The previous flat
      // `elevation: 0` override is dropped; in the monochrome scheme the
      // surfaceTint at 6dp is ~indistinguishable from the container color.
    );
  }

  static ProgressIndicatorThemeData progressIndicator(AppThemeColors colors) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.muted,
      circularTrackColor: colors.muted,
      linearMinHeight: 4,
    );
  }

  /// Flat 4px track, solid thumb; M3 hover/focus/pressed overlay restored
  /// (the shadcn-era `overlayColor: transparent` + zero-radius overlay
  /// suppression is dropped so the slider shows its state layer again).
  static SliderThemeData slider(AppThemeColors colors, TextTheme textTheme) {
    return SliderThemeData(
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.muted,
      disabledActiveTrackColor: colors.primary.withValues(
        alpha: OpacityTokens.disabledSurface,
      ),
      disabledInactiveTrackColor: colors.muted,
      thumbColor: colors.primary,
      disabledThumbColor: colors.primary.withValues(
        alpha: OpacityTokens.disabledSurface,
      ),
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      valueIndicatorShape: const DropSliderValueIndicatorShape(),
      valueIndicatorColor: colors.popover,
      valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(
        color: colors.popoverForeground,
      ),
      showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    );
  }

  /// Notification badges follow the primary color. smallSize is a dot-only badge.
  static BadgeThemeData badge(AppThemeColors colors, TextTheme textTheme) {
    return BadgeThemeData(
      backgroundColor: colors.primary,
      textColor: colors.primaryForeground,
      smallSize: 6,
      largeSize: 16,
      textStyle: textTheme.labelSmall,
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.sm),
    );
  }

  /// Used for accordion / settings sections. Border-bottom only, transparent bg.
  static ExpansionTileThemeData expansionTile(AppThemeColors colors) {
    return ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: colors.mutedForeground,
      collapsedIconColor: colors.mutedForeground,
      textColor: colors.foreground,
      collapsedTextColor: colors.foreground,
      tilePadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.xs,
      ),
      childrenPadding: const EdgeInsets.only(bottom: SpacingTokens.md),
      // Border-bottom only — consistent with shadcn/ui list divider pattern.
      shape: Border(bottom: BorderSide(color: colors.border)),
      collapsedShape: Border(bottom: BorderSide(color: colors.border)),
    );
  }

  /// Minimal pill scrollbar — visible only on hover/drag, transparent track.
  static ScrollbarThemeData scrollbar(AppThemeColors colors) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged) ||
            states.contains(WidgetState.hovered)) {
          // More visible when interacting.
          return colors.mutedForeground;
        }
        // Subtle at rest — consistent with shadcn/ui's minimal aesthetic.
        return colors.border;
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
  /// pressed feedback comes from the M3 state layer and ripple (restored in
  /// Wave 0) instead of the old shadcn accent hover.
  static MenuButtonThemeData menuButton(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.disabledContent,
            );
          }
          return colors.foreground;
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
