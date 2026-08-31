// dart run build_runner build --delete-conflicting-outputs
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:material_ui/material_ui.dart';

part 'app_theme_extension.freezed.dart';

// ── AppStatusColors ───────────────────────────────────────────────────────────

/// Immutable snapshot of all status/semantic color tokens — success, warning,
/// info, error — along with their foregrounds and container variants.
///
/// Extracted from the flat [AppThemeColors] field list so that:
///   1. Status tokens can be extended independently (e.g. adding `successSubtle`)
///      without touching the core semantic section.
///   2. [AppThemeColors.lerp] delegates to [AppStatusColors.lerp] — one line
///      instead of eight, and maintenance stays bounded regardless of how many
///      status variants are added.
///   3. Consumer API is more expressive:
///        `colors.status.success`  vs  `colors.success`
///
/// ## Container fields (added 03 Jul 2026 palette swap)
///
/// Every status type carries a `*Container`/`*ContainerForeground` pair for
/// tonal/soft-filled badge UI, symmetric across success/warning/info/error —
/// even though the source palette only supplies real designed container
/// tokens for success/warning/error. `info`'s container is derived (see
/// [ColorTokens.lightInfoContainer]) precisely so this API stays symmetric;
/// consumers should never need to special-case info.
///
/// ## Usage
/// ```dart
/// final s = context.colors.status;
/// Container(color: s.warning, child: Text('!', style: TextStyle(color: s.warningForeground)));
/// Container(color: s.successContainer, child: Text('OK', style: TextStyle(color: s.successContainerForeground)));
/// ```
@freezed
abstract class AppStatusColors with _$AppStatusColors {
  const factory AppStatusColors({
    required Color success,
    required Color successForeground,
    required Color warning,
    required Color warningForeground,
    required Color info,
    required Color infoForeground,
    required Color error,
    required Color errorForeground,
    // ── Container variants (tonal badge/chip surfaces) ────────────────────────
    required Color successContainer,
    required Color successContainerForeground,
    required Color warningContainer,
    required Color warningContainerForeground,
    required Color infoContainer,
    required Color infoContainerForeground,
    required Color errorContainer,
    required Color errorContainerForeground,
  }) = _AppStatusColors;

  /// Linearly interpolates between [a] and [b] at fraction [t].
  /// Delegated to from [AppThemeColors.lerp] — keeps the parent lerp
  /// to a single line for the entire status group.
  factory AppStatusColors.lerp(AppStatusColors a, AppStatusColors b, double t) {
    return AppStatusColors(
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
      successContainer: Color.lerp(a.successContainer, b.successContainer, t)!,
      successContainerForeground: Color.lerp(
        a.successContainerForeground,
        b.successContainerForeground,
        t,
      )!,
      warningContainer: Color.lerp(a.warningContainer, b.warningContainer, t)!,
      warningContainerForeground: Color.lerp(
        a.warningContainerForeground,
        b.warningContainerForeground,
        t,
      )!,
      infoContainer: Color.lerp(a.infoContainer, b.infoContainer, t)!,
      infoContainerForeground: Color.lerp(
        a.infoContainerForeground,
        b.infoContainerForeground,
        t,
      )!,
      errorContainer: Color.lerp(a.errorContainer, b.errorContainer, t)!,
      errorContainerForeground: Color.lerp(
        a.errorContainerForeground,
        b.errorContainerForeground,
        t,
      )!,
    );
  }
}

// ── AppThemeColors ────────────────────────────────────────────────────────────

/// Immutable snapshot of every shadcn/ui color token resolved for a
/// specific [Brightness]. Consumed by [AppThemeExtension] and
/// [ThemeConstants] factory methods.
///
/// ## Why Freezed?
///
/// Freezed generates [==], [hashCode], and [copyWith] from the single field
/// declaration — always in sync by construction. Adding a core token is
/// one line change. The compiler surfaces any missing required parameter
/// at every call site.
///
/// ## Status tokens
///
/// Status colors live in the [AppStatusColors] sub-record ([status] field)
/// rather than as flat fields. This keeps the core semantic section lean
/// and makes [lerp] maintenance O(1) for the status group.
///
/// ## accent2 (added 03 Jul 2026 palette swap)
///
/// Maps to Material 3's `secondaryContainer`/`onSecondaryContainer` roles in
/// [ThemeConstants.colorSchemeFrom] — per the source palette's own token
/// comments, this is a purpose-built "Secondary Container" swatch, not a
/// generic extra accent. Kept as a flat field (like the rest of the core
/// section) rather than its own sub-record, since it's a single pair, not a
/// family of roles the way status colors are.
///
/// ## What Freezed does NOT generate
///
/// [AppThemeColors.lerp] is kept manual because Freezed has no domain
/// knowledge that every field is a [Color]. When you add a new core token
/// field, add the corresponding [Color.lerp] line here; the compiler will
/// surface the gap as a missing required named parameter at the call site.
@freezed
abstract class AppThemeColors with _$AppThemeColors {
  const factory AppThemeColors({
    // ── Core semantic tokens ─────────────────────────────────────────────────
    required Color background,
    required Color foreground,
    required Color card,
    required Color cardForeground,
    required Color popover,
    required Color popoverForeground,
    required Color primary,
    required Color primaryForeground,
    required Color secondary,
    required Color secondaryForeground,
    required Color muted,
    required Color mutedForeground,
    required Color accent,
    required Color accentForeground,
    required Color accent2,
    required Color accent2Foreground,
    required Color destructive,
    required Color destructiveForeground,
    required Color border,
    required Color input,
    required Color ring,
    // ── Status tokens (grouped) ───────────────────────────────────────────────
    required AppStatusColors status,
  }) = _AppThemeColors;

  // ── Interpolation ──────────────────────────────────────────────────────────

  /// Linearly interpolates between [a] and [b] at fraction [t].
  /// Used by [AppThemeExtension.lerp] during animated theme transitions.
  ///
  /// MAINTENANCE NOTE: when you add a new core token field above, add the
  /// corresponding [Color.lerp] line here. Status tokens are handled by
  /// [AppStatusColors.lerp] — no changes needed here for status additions.
  factory AppThemeColors.lerp(AppThemeColors a, AppThemeColors b, double t) {
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
      accent2: Color.lerp(a.accent2, b.accent2, t)!,
      accent2Foreground: Color.lerp(
        a.accent2Foreground,
        b.accent2Foreground,
        t,
      )!,
      destructive: Color.lerp(a.destructive, b.destructive, t)!,
      destructiveForeground: Color.lerp(
        a.destructiveForeground,
        b.destructiveForeground,
        t,
      )!,
      border: Color.lerp(a.border, b.border, t)!,
      input: Color.lerp(a.input, b.input, t)!,
      ring: Color.lerp(a.ring, b.ring, t)!,
      // Status group — delegated; one line regardless of status token count.
      status: AppStatusColors.lerp(a.status, b.status, t),
    );
  }
}

// ── ThemeExtension ────────────────────────────────────────────────────────────

/// Material 3 [ThemeExtension] that carries the full [AppThemeColors] snapshot
/// into the widget tree.
///
/// Access it anywhere with:
/// ```dart
/// final colors = AppThemeExtension.of(context).colors;
/// ```
///
/// Or via the convenience extension in `extensions.dart`:
/// ```dart
/// final colors = context.colors;
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
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      colors: AppThemeColors.lerp(colors, other.colors, t),
    );
  }

  // ── Convenience accessor ─────────────────────────────────────────────────────

  /// Retrieves [AppThemeExtension] from the nearest [Theme].
  ///
  /// Throws a descriptive [StateError] in all build modes (debug and release)
  /// if the extension is not registered — more informative than the generic
  /// "Null check operator used on a null value" that a bare `ext!` would give.
  static AppThemeExtension of(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>();
    if (ext == null) {
      throw StateError(
        'AppThemeExtension not found in ThemeData. '
        'Ensure AppTheme.light() or AppTheme.dark() is used to build your '
        'ThemeData — both register AppThemeExtension in their extensions list.',
      );
    }
    return ext;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppThemeExtension && other.colors == colors;
  }

  @override
  int get hashCode => colors.hashCode;
}
