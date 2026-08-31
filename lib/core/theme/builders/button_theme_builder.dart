import 'package:material_ui/material_ui.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds every button-family [ThemeData] sub-theme (elevated, outlined,
/// text, segmented, FAB) from [AppThemeColors] + [TextTheme].
///
/// Extracted from `app_theme.dart` — that file held all ~40 widget themes
/// in a single 800+ line static method, which made even a one-line tweak
/// to (say) the outlined button's hover color a risky diff to review and
/// a likely merge-conflict magnet against anyone else touching the same
/// file. Splitting by widget family keeps each concern small without
/// changing a single resolved value: every property below is copied
/// verbatim from the pre-split implementation.
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
          // `focused` is grouped with `hovered` — with `highlightColor` and
          // `splashFactory` nulled out app-wide (see [AppTheme._build]),
          // this overlay is the ONLY visual feedback a keyboard/tab user
          // gets when this button receives focus. Without it the button
          // would show no focus indicator at all.
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return colors.primaryForeground.withValues(
              alpha: OpacityTokens.hover,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return colors.primaryForeground.withValues(
              alpha: OpacityTokens.pressed,
            );
          }
          return Colors.transparent;
        }),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
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
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
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
          return colors.foreground;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
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
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          // `overlayColor` below is permanently transparent (NoSplash /
          // flat shadcn aesthetic), so hover/focus feedback for this
          // ghost-style button has to live on `backgroundColor` instead —
          // `focused` is grouped with `hovered` so keyboard/tab users get
          // the same visible tint a mouse user gets.
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
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
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
          if (states.contains(WidgetState.selected)) {
            return colors.primaryForeground;
          }
          return colors.foreground;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
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
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      splashColor: colors.primaryForeground.withValues(
        alpha: OpacityTokens.pressed,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
      ),
    );
  }
}
