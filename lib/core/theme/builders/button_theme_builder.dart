import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds every button-family [ThemeData] sub-theme (elevated, outlined,
/// text, segmented, FAB) from [AppThemeColors] + [TextTheme].
///
/// Extracted from `app_theme.dart` — that file held all ~40 widget themes
/// in a single 800+ line static method, which made even a one-line tweak
/// to (say) the outlined button's hover color a risky diff to review and
/// a likely merge-conflict magnet against anyone else touching the same
/// file. Splitting by widget family keeps each concern small.
///
/// Wave 1 M3 core refactor: the four regular button shapes moved onto the
/// M3 button shape category (full / pill — m3.material.io/components/buttons,
/// round-default corner size), the FAB onto the M3 rounded-square shape
/// (large 16dp) with its elevation restored to the 6dp baseline, and the
/// shadcn-era state-layer suppression (transparent `overlayColor`, accent
/// hover fills) removed in favor of the M3 state layers — hover 8%, focus
/// 12%, pressed 12% (m3.material.io/foundations/interaction/states), using
/// the on-color of each container (onSurface / onPrimary) — that Wave 0's
/// interaction-default restoration re-enabled.
///
/// Pure functions — given the same [colors]/[textTheme] they always
/// return the same `ThemeData` sub-object, exactly like [AppTheme] itself.
abstract final class ButtonThemeBuilder {
  /// Minimum tap target for every themed button family below.
  ///
  /// Height was previously 40 — below both Android's Material 48dp and iOS
  /// HIG's 44pt minimum touch-target guidance. Bumped to 48 as part of the
  /// 01 Jul 2026 production-readiness audit: this app already invests in
  /// keyboard-focus and reduce-motion accessibility (see the `focused`
  /// state handling throughout this file), so touch-target size was the
  /// one accessibility dimension still below standard. Width (64) is
  /// unaffected — only height mattered for the touch-target guideline.
  static const Size _minimumButtonSize = Size(64, 48);

  /// Elevated button — shadcn/ui "default" / primary variant.
  static ElevatedButtonThemeData elevatedButton(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            // Both bg and fg use disabledSurface (0.5) so the entire button
            // dims uniformly, matching shadcn's muted-but-visible disabled look.
            return colors.primary.withValues(
              alpha: OpacityTokens.disabledSurface,
            );
          }
          return colors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.primaryForeground.withValues(
              alpha: OpacityTokens.disabledSurface,
            );
          }
          return colors.primaryForeground;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          // M3 state layer for a primary-filled button: onPrimary (the
          // container's on-color) at hover 8% / focus 12% / pressed 12%
          // (m3.material.io/foundations/interaction/states). Must stay
          // explicit — the framework's default elevated-button overlay is
          // `primary`-tinted, which would be invisible on this button's
          // solid primary fill.
          if (states.contains(WidgetState.hovered)) {
            return colors.primaryForeground.withValues(
              alpha: OpacityTokens.hover,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return colors.primaryForeground.withValues(
              alpha: OpacityTokens.focusOverlay,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.primaryForeground.withValues(
              alpha: OpacityTokens.pressed,
            );
          }
          return Colors.transparent;
        }),
        // This is styled as an M3 filled button (primary / onPrimary), and
        // the M3 filled config is flat — 0dp elevation, no shadow. Kept as-is.
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          // M3 button shape category: full (pill) — round-default corner size.
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.full),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: SpacingTokens.xl,
            vertical: SpacingTokens.lg,
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          textTheme.labelLarge?.copyWith(
            fontWeight: TypographyTokens.weightMedium,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(_minimumButtonSize),
      ),
    );
  }

  /// Outlined button — shadcn/ui "outline" variant.
  static OutlinedButtonThemeData outlinedButton(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        // Transparent container at every state — hover/focus/pressed feedback
        // comes from the onSurface state layer below (the old shadcn accent
        // hover fill would now resolve to a near-black solid).
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.disabledContent,
            );
          }
          return colors.foreground;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          // M3 state layer for a transparent outlined button: onSurface at
          // hover 8% / focus 12% / pressed 12%.
          if (states.contains(WidgetState.hovered)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.hover,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.focusOverlay,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.pressed,
            );
          }
          return Colors.transparent;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: colors.border.withValues(
                alpha: OpacityTokens.disabledSurface,
              ),
            );
          }
          if (states.contains(WidgetState.focused)) {
            return BorderSide(color: colors.ring, width: BorderWidthTokens.lg);
          }
          return BorderSide(color: colors.border);
        }),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          // M3 button shape category: full (pill) — round-default corner size.
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.full),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: SpacingTokens.xl,
            vertical: SpacingTokens.lg,
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          textTheme.labelLarge?.copyWith(
            fontWeight: TypographyTokens.weightMedium,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(_minimumButtonSize),
      ),
    );
  }

  /// Text button — shadcn/ui "ghost" variant.
  static TextButtonThemeData textButton(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return TextButtonThemeData(
      style: ButtonStyle(
        // Transparent container — hover/focus/pressed feedback comes from the
        // onSurface state layer below, matching the M3 text-button spec.
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.disabledContent,
            );
          }
          // Label stays onSurface in every enabled state — M3 state layers
          // carry the feedback, not a label-color swap (the old hover branch
          // switched to accentForeground, which now resolves to near-white
          // and lost contrast against the surface).
          return colors.foreground;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          // M3 state layer for a transparent text button: onSurface at
          // hover 8% / focus 12% / pressed 12%.
          if (states.contains(WidgetState.hovered)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.hover,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.focusOverlay,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.pressed,
            );
          }
          return Colors.transparent;
        }),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          // M3 button shape category: full (pill) — round-default corner size.
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.full),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: SpacingTokens.xl,
            vertical: SpacingTokens.lg,
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          textTheme.labelLarge?.copyWith(
            fontWeight: TypographyTokens.weightMedium,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(_minimumButtonSize),
      ),
    );
  }

  /// Segmented button — shadcn/ui's ToggleGroup equivalent.
  ///
  /// Selected segment uses primary; unselected is transparent with border.
  static SegmentedButtonThemeData segmentedButton(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          // Unselected: transparent — feedback comes from the onSurface state
          // layer below (the old accent hover fill resolved to a near-black
          // solid, indistinguishable from the selected fill).
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.disabledContent,
            );
          }
          if (states.contains(WidgetState.selected)) {
            return colors.primaryForeground;
          }
          return colors.foreground;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          // M3 state layers — onPrimary over the selected primary fill,
          // onSurface over the transparent unselected container — at hover
          // 8% / focus 12% / pressed 12%. The old transparent overlay
          // suppressed both the state layer and the ripple.
          if (states.contains(WidgetState.selected)) {
            if (states.contains(WidgetState.hovered)) {
              return colors.primaryForeground.withValues(
                alpha: OpacityTokens.hover,
              );
            }
            if (states.contains(WidgetState.focused)) {
              return colors.primaryForeground.withValues(
                alpha: OpacityTokens.focusOverlay,
              );
            }
            if (states.contains(WidgetState.pressed)) {
              return colors.primaryForeground.withValues(
                alpha: OpacityTokens.pressed,
              );
            }
            return Colors.transparent;
          }
          if (states.contains(WidgetState.hovered)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.hover,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.focusOverlay,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.foreground.withValues(
              alpha: OpacityTokens.pressed,
            );
          }
          return Colors.transparent;
        }),
        // Explicit 48dp minimum, matching [elevatedButton] / [outlinedButton]
        // / [textButton] above. Added during the same audit that raised
        // those three from 40 → 48 — this one was the gap left behind: it
        // never had an explicit minimumSize at all, relying on
        // SegmentedButton's Material 3 default sizing instead of this
        // builder's own touch-target guarantee. Used live in
        // `SettingsPage` for the light/dark/system theme-mode toggle.
        minimumSize: const WidgetStatePropertyAll(_minimumButtonSize),
        side: WidgetStateProperty.resolveWith((states) {
          // Was `BorderSide(color: colors.border)` returned unconditionally
          // — `states` was read but never branched on, so every segment
          // (including focused ones) rendered an identical border. Now
          // mirrors [outlinedButton]'s ring treatment so a focused segment
          // is actually distinguishable from its neighbours.
          if (states.contains(WidgetState.focused)) {
            return BorderSide(color: colors.ring, width: BorderWidthTokens.lg);
          }
          return BorderSide(color: colors.border);
        }),
        shape: WidgetStatePropertyAll(
          // M3 segmented button shape category: full (pill).
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.full),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          textTheme.labelLarge?.copyWith(
            fontWeight: TypographyTokens.weightMedium,
          ),
        ),
      ),
    );
  }

  /// Floating action button.
  static FloatingActionButtonThemeData floatingActionButton(
    AppThemeColors colors,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.primaryForeground,
      // M3 FAB elevation baseline: 6dp rest / focus, 8dp hover, 6dp pressed
      // (Flutter's `_FABDefaultsM3`). The previous all-zero override was the
      // flat shadcn treatment — tonal elevation is restored here.
      elevation: 6,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 6,
      splashColor: colors.primaryForeground.withValues(
        alpha: OpacityTokens.pressed,
      ),
      shape: RoundedRectangleBorder(
        // M3 FAB shape: rounded square, 16dp corners for the regular 56dp FAB
        // (m3.material.io/components/floating-action-button — "boxier shape";
        // Flutter `_FABDefaultsM3` regular = RoundedRectangleBorder 16). Not
        // the `full` category — that's the pre-M3 circular FAB.
        borderRadius: BorderRadius.circular(RadiusTokens.large),
      ),
    );
  }
}
