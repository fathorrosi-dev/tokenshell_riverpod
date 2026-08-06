import 'package:flutter/material.dart';
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
/// shared code. Any token change (e.g. a new focus border width) required
/// updating both, with silent drift as the failure mode.
///
/// [_outlineBorder] and [_focusedBorder] are now the single source of truth
/// for those constructions. Both public methods delegate to them, so token
/// updates propagate everywhere automatically.
abstract final class InputThemeBuilder {
  // ── Private border helpers ─────────────────────────────────────────────────

  /// An [OutlineInputBorder] at the M3 text-field shape radius
  /// ([RadiusTokens.extraSmall], 4 dp) with [color] as the single-pixel border
  /// side.
  ///
  /// Used for [InputDecorationTheme.border], [enabledBorder], and
  /// [disabledBorder] — any state where the border is normal weight.
  static OutlineInputBorder _outlineBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
    borderSide: BorderSide(color: color),
  );

  /// An [OutlineInputBorder] at the M3 text-field shape radius
  /// ([RadiusTokens.extraSmall], 4 dp) with [emphasizedColor] and
  /// [BorderWidthTokens.lg] (2 px) — the M3 2dp emphasized outline.
  ///
  /// Used for [InputDecorationTheme.focusedBorder] and both error borders
  /// ([errorBorder] and [focusedErrorBorder]) — M3 specs the outlined
  /// text-field outline at 2 dp for the focused and error states alike — and
  /// mirrored in the dropdown [MenuStyle]. Centralised here so changing the
  /// emphasized width or radius updates every input and dropdown in one place.
  static OutlineInputBorder _focusedBorder(Color emphasizedColor) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
        borderSide: BorderSide(
          color: emphasizedColor,
          width: BorderWidthTokens.lg,
        ),
      );

  // ── Public builders ────────────────────────────────────────────────────────

  /// Default [InputDecorationTheme] used by [TextField] / [TextFormField].
  static InputDecorationTheme inputDecoration(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.lg,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant,
      ),
      floatingLabelStyle: textTheme.bodySmall?.copyWith(
        color: colors.onSurface,
        fontWeight: TypographyTokens.weightMedium,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: colors.error),
      border: _outlineBorder(colors.outline),
      enabledBorder: _outlineBorder(colors.outline),
      // M3 has no dedicated "focus ring" role — primary is this app's
      // deliberate stand-in for focus indication (see theme_constants.dart).
      focusedBorder: _focusedBorder(colors.primary),
      errorBorder: _focusedBorder(colors.error),
      focusedErrorBorder: _focusedBorder(colors.error),
      disabledBorder: _outlineBorder(
        colors.outline.withValues(alpha: OpacityTokens.disabledSurface),
      ),
    );
  }

  /// [DropdownMenuThemeData] — matches popover-style overlay styling (same
  /// bg, border, radius as other overlays) while its menu container keeps
  /// the M3 menu elevation default (level 2 shadow). Its nested
  /// [InputDecorationTheme] intentionally mirrors [inputDecoration] above to
  /// stay visually consistent; both now delegate to [_outlineBorder] /
  /// [_focusedBorder] so token changes propagate to both without manual
  /// synchronisation.
  static DropdownMenuThemeData dropdownMenu(
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return DropdownMenuThemeData(
      textStyle: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colors.surfaceContainerHigh),
        // Menus stay untinted in M3: Flutter's menu default is a transparent
        // surfaceTint — menus elevate via shadow (level 2, 3 dp), not tonal
        // tint. `elevation` / `shadowColor` are left unset so the M3 defaults
        // (3 dp, scheme.shadow) apply.
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusTokens.extraSmall),
            side: BorderSide(color: colors.outlineVariant),
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
        border: _outlineBorder(colors.outline),
        enabledBorder: _outlineBorder(colors.outline),
        focusedBorder: _focusedBorder(colors.primary),
      ),
    );
  }
}
