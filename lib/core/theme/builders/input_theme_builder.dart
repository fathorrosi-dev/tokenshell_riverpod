import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';

/// Builds form-input related [ThemeData] sub-themes.
///
/// See `button_theme_builder.dart` for the rationale behind splitting
/// `app_theme.dart` by widget family — every value here is unchanged from
/// the pre-split implementation.
///
/// ## DRY refactor (R8)
///
/// [InputDecorationTheme] (for [TextField]) and the nested
/// [InputDecorationTheme] inside [DropdownMenuThemeData] previously defined
/// [OutlineInputBorder] variants independently — identical border radii,
/// border colors, and focus widths duplicated across two methods with no
/// shared code. Any token change (e.g. a new focus ring width) required
/// updating both, with silent drift as the failure mode.
///
/// [_outlineBorder] and [_focusedBorder] are now the single source of truth
/// for those constructions. Both public methods delegate to them, so token
/// updates propagate everywhere automatically.
abstract final class InputThemeBuilder {
  // ── Private border helpers ─────────────────────────────────────────────────

  /// An [OutlineInputBorder] at the standard [RadiusTokens.md] radius with
  /// [color] as the single-pixel border side.
  ///
  /// Used for [InputDecorationTheme.border], [enabledBorder], [errorBorder],
  /// and [disabledBorder] — any state where the border is normal weight.
  static OutlineInputBorder _outlineBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(RadiusTokens.md),
    borderSide: BorderSide(color: color),
  );

  /// An [OutlineInputBorder] at the standard [RadiusTokens.md] radius with
  /// [ringColor] and [BorderWidthTokens.lg] (2 px) — the "focused" weight.
  ///
  /// Used for [InputDecorationTheme.focusedBorder] and
  /// [InputDecorationTheme.focusedErrorBorder], and mirrored in the dropdown
  /// [MenuStyle]. Centralised here so changing the focus ring width or radius
  /// updates every input and dropdown in one place.
  static OutlineInputBorder _focusedBorder(Color ringColor) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        borderSide: BorderSide(color: ringColor, width: BorderWidthTokens.lg),
      );

  // ── Public builders ────────────────────────────────────────────────────────

  /// Default [InputDecorationTheme] used by [TextField] / [TextFormField].
  static InputDecorationTheme inputDecoration(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.lg,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colors.mutedForeground,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colors.mutedForeground,
      ),
      floatingLabelStyle: textTheme.bodySmall?.copyWith(
        color: colors.foreground,
        fontWeight: TypographyTokens.weightMedium,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: colors.destructive,
      ),
      border: _outlineBorder(colors.input),
      enabledBorder: _outlineBorder(colors.input),
      focusedBorder: _focusedBorder(colors.ring),
      errorBorder: _outlineBorder(colors.destructive),
      focusedErrorBorder: _focusedBorder(colors.destructive),
      disabledBorder: _outlineBorder(
        colors.input.withValues(alpha: OpacityTokens.disabledSurface),
      ),
    );
  }

  /// [DropdownMenuThemeData] — matches popover styling (same bg, border,
  /// radius, shadow as other overlays). Its nested [InputDecorationTheme]
  /// intentionally mirrors [inputDecoration] above to stay visually
  /// consistent; both now delegate to [_outlineBorder] / [_focusedBorder]
  /// so token changes propagate to both without manual synchronisation.
  static DropdownMenuThemeData dropdownMenu(
    AppThemeColors colors,
    TextTheme textTheme,
  ) {
    return DropdownMenuThemeData(
      textStyle: textTheme.bodyMedium?.copyWith(color: colors.foreground),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colors.popover),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            side: BorderSide(color: colors.border),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: SpacingTokens.xs),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.xl,
          vertical: SpacingTokens.lg,
        ),
        border: _outlineBorder(colors.input),
        enabledBorder: _outlineBorder(colors.input),
        focusedBorder: _focusedBorder(colors.ring),
      ),
    );
  }
}
