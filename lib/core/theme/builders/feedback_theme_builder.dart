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
/// `app_theme.dart` by widget family — every value here is unchanged from
/// the pre-split implementation.
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
      side: BorderSide(color: colors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
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
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  static CheckboxThemeData checkbox(AppThemeColors colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.muted;
        if (states.contains(WidgetState.selected)) return colors.primary;
        // Hover/focus on an unselected checkbox: apply a very subtle accent
        // background tint so the user sees the control is interactive before
        // clicking. The border change below is the primary focus indicator —
        // this fill is additive, not the sole signal.
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return colors.accent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(colors.primaryForeground),
      side: WidgetStateBorderSide.resolveWith((states) {
        // selected → primary (solid fill matches the border — clear checked state).
        if (states.contains(WidgetState.selected)) {
          return BorderSide(
            color: colors.primary,
            width: BorderWidthTokens.md,
          );
        }
        // disabled → muted (recedes, signals non-interactable).
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colors.muted,
            width: BorderWidthTokens.md,
          );
        }
        // focused → ring color at 2 px width. Mirrors the focused input border
        // treatment (focusedBorder uses ring + BorderWidthTokens.lg) so keyboard
        // focus on a checkbox looks consistent with focus on any TextField.
        // splashFactory is NoSplash app-wide, so this border change is the ONLY
        // visual signal a keyboard/tab user gets when this checkbox is focused —
        // without it, the control would show zero focus indicator.
        if (states.contains(WidgetState.focused)) {
          return BorderSide(
            color: colors.ring,
            width: BorderWidthTokens.lg,
          );
        }
        // hovered → primary border at normal width. More prominent than input
        // color at rest, signalling the control is about to be clicked.
        if (states.contains(WidgetState.hovered)) {
          return BorderSide(
            color: colors.primary,
            width: BorderWidthTokens.md,
          );
        }
        // unselected (default) → input token (zinc-200 light / gray-700 dark).
        // Using the input border color (same as TextField) makes unchecked
        // checkboxes visually consistent with the rest of the form — lighter
        // weight so they don't compete for attention in a list of fields.
        // The previous value (colors.primary, near-black) made every unchecked
        // checkbox as visually heavy as a selected one.
        return BorderSide(
          color: colors.input,
          width: BorderWidthTokens.md,
        );
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
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
        // Radio doesn't have a separate `side` property like Checkbox, so
        // fillColor is the only channel for hover/focus visual feedback.
        // focused → ring color: mirrors the "focused input" signal used
        //   throughout the rest of the design system. splashFactory is
        //   NoSplash app-wide, making this the ONLY visible cue for keyboard
        //   users — without it the focused radio shows zero indicator.
        // hovered → foreground (near-black / near-white per brightness):
        //   more prominent than mutedForeground at rest, signals interactability
        //   before clicking without jumping straight to primary.
        if (states.contains(WidgetState.focused)) return colors.ring;
        if (states.contains(WidgetState.hovered)) return colors.foreground;
        return colors.mutedForeground;
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
        borderRadius: BorderRadius.circular(RadiusTokens.md),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
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

  /// shadcn/ui slider: no visible overlay, flat track at 4px, solid thumb.
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
      // No focus/hover overlay — keeps the shadcn flat aesthetic.
      // RoundSliderOverlayShape(overlayRadius: 0) is the semantically correct
      // way to suppress the overlay; SliderComponentShape.noThumb was intended
      // for thumbShape, not overlayShape, and could behave unexpectedly on
      // future Flutter SDK updates.
      overlayColor: Colors.transparent,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
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

  /// MenuAnchor / SubmenuButton items. Accent hover matches the ghost
  /// button pattern used elsewhere in shadcn.
  static MenuButtonThemeData menuButton(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return colors.accent;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.disabledContent,
            );
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return colors.accentForeground;
          }
          return colors.foreground;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
            borderRadius: BorderRadius.circular(RadiusTokens.sm),
          ),
        ),
      ),
    );
  }
}
