import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme.dart';
import 'package:tokenshell_riverpod/core/theme/theme_constants.dart';

/// Immutable snapshot of every shadcn/ui color token resolved for a
/// specific [Brightness]. Consumed by [AppThemeExtension] and
/// [ThemeConstants] factory methods.
@immutable
final class AppThemeColors {
  const AppThemeColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.success,
    required this.successForeground,
    required this.warning,
    required this.warningForeground,
    required this.info,
    required this.infoForeground,
    required this.error,
    required this.errorForeground,
  });

  // ── Interpolation ────────────────────────────────────────────────────────────

  /// Linearly interpolates between [a] and [b] at fraction [t].
  /// Used by [AppThemeExtension.lerp] during animated theme transitions.
  factory AppThemeColors.lerp(
    AppThemeColors a,
    AppThemeColors b,
    double t,
  ) {
    return AppThemeColors(
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      card: Color.lerp(a.card, b.card, t)!,
      cardForeground: Color.lerp(a.cardForeground, b.cardForeground, t)!,
      popover: Color.lerp(a.popover, b.popover, t)!,
      popoverForeground: Color.lerp(
        a.popoverForeground,
        b.popoverForeground,
        t,
      )!,
      primary: Color.lerp(a.primary, b.primary, t)!,
      primaryForeground: Color.lerp(
        a.primaryForeground,
        b.primaryForeground,
        t,
      )!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      secondaryForeground: Color.lerp(
        a.secondaryForeground,
        b.secondaryForeground,
        t,
      )!,
      muted: Color.lerp(a.muted, b.muted, t)!,
      mutedForeground: Color.lerp(a.mutedForeground, b.mutedForeground, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentForeground: Color.lerp(a.accentForeground, b.accentForeground, t)!,
      destructive: Color.lerp(a.destructive, b.destructive, t)!,
      destructiveForeground: Color.lerp(
        a.destructiveForeground,
        b.destructiveForeground,
        t,
      )!,
      border: Color.lerp(a.border, b.border, t)!,
      input: Color.lerp(a.input, b.input, t)!,
      ring: Color.lerp(a.ring, b.ring, t)!,
      success: Color.lerp(a.success, b.success, t)!,
      successForeground: Color.lerp(
        a.successForeground,
        b.successForeground,
        t,
      )!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      warningForeground: Color.lerp(
        a.warningForeground,
        b.warningForeground,
        t,
      )!,
      info: Color.lerp(a.info, b.info, t)!,
      infoForeground: Color.lerp(a.infoForeground, b.infoForeground, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      errorForeground: Color.lerp(a.errorForeground, b.errorForeground, t)!,
    );
  }

  // ── Core semantic tokens ─────────────────────────────────────────────────────

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;

  // ── Status tokens ────────────────────────────────────────────────────────────

  final Color success;
  final Color successForeground;
  final Color warning;
  final Color warningForeground;
  final Color info;
  final Color infoForeground;
  final Color error;
  final Color errorForeground;

  // ── Mutation ─────────────────────────────────────────────────────────────────

  AppThemeColors copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? info,
    Color? infoForeground,
    Color? error,
    Color? errorForeground,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      info: info ?? this.info,
      infoForeground: infoForeground ?? this.infoForeground,
      error: error ?? this.error,
      errorForeground: errorForeground ?? this.errorForeground,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppThemeColors &&
        other.background == background &&
        other.foreground == foreground &&
        other.card == card &&
        other.cardForeground == cardForeground &&
        other.popover == popover &&
        other.popoverForeground == popoverForeground &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground &&
        other.accent == accent &&
        other.accentForeground == accentForeground &&
        other.destructive == destructive &&
        other.destructiveForeground == destructiveForeground &&
        other.border == border &&
        other.input == input &&
        other.ring == ring &&
        other.success == success &&
        other.successForeground == successForeground &&
        other.warning == warning &&
        other.warningForeground == warningForeground &&
        other.info == info &&
        other.infoForeground == infoForeground &&
        other.error == error &&
        other.errorForeground == errorForeground;
  }

  @override
  int get hashCode => Object.hashAll([
    background,
    foreground,
    card,
    cardForeground,
    popover,
    popoverForeground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    input,
    ring,
    success,
    successForeground,
    warning,
    warningForeground,
    info,
    infoForeground,
    error,
    errorForeground,
  ]);
}

// ── ThemeExtension ────────────────────────────────────────────────────────────

/// Material 3 [ThemeExtension] that carries the full [AppThemeColors] snapshot
/// into the widget tree.
///
/// Access it anywhere with:
/// ```dart
/// final colors = AppThemeExtension.of(context).colors;
/// ```
@immutable
final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({required this.colors});

  /// The resolved shadcn/ui color tokens for the current brightness.
  final AppThemeColors colors;

  // ── ThemeExtension contract ──────────────────────────────────────────────────

  @override
  AppThemeExtension copyWith({AppThemeColors? colors}) {
    return AppThemeExtension(colors: colors ?? this.colors);
  }

  @override
  AppThemeExtension lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      colors: AppThemeColors.lerp(colors, other.colors, t),
    );
  }

  // ── Convenience accessor ─────────────────────────────────────────────────────

  /// Retrieves [AppThemeExtension] from the nearest [Theme].
  /// Throws if the extension is not registered — always register via [AppTheme].
  static AppThemeExtension of(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>();
    assert(
      ext != null,
      'AppThemeExtension not found in Theme. '
      'Make sure you use AppTheme.light() or AppTheme.dark().',
    );
    return ext!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppThemeExtension && other.colors == colors;
  }

  @override
  int get hashCode => colors.hashCode;
}
