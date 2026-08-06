// dart run build_runner build --delete-conflicting-outputs
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_extension.freezed.dart';

// ── AppStatusColors ───────────────────────────────────────────────────────────

/// Immutable snapshot of all status/semantic color tokens — success, warning,
/// info, error — along with their foregrounds.
///
/// Material 3's [ColorScheme] does not define native roles for these four
/// semantic states (it only ships `error`/`onError`), so they live in their
/// own [ThemeExtension] rather than as a duplicate wrapper around the roles
/// [ColorScheme] already provides. Any color that DOES have a native M3
/// role (surface, primary, outline, etc.) is read directly from
/// `Theme.of(context).colorScheme` — see `extensions.dart`.
///
/// ## Usage
/// ```dart
/// final s = context.statusColors;
/// Container(color: s.warning, child: Text('!', style: TextStyle(color: s.warningForeground)));
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
  }) = _AppStatusColors;

  /// Linearly interpolates between [a] and [b] at fraction [t].
  /// Used by [AppThemeExtension.lerp] during animated theme transitions.
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
    );
  }
}

// ── ThemeExtension ────────────────────────────────────────────────────────────

/// Material 3 [ThemeExtension] that carries the app's [AppStatusColors]
/// snapshot into the widget tree.
///
/// ## Why this extension is deliberately thin
///
/// Earlier revisions of this file also carried a 19-field `AppThemeColors`
/// snapshot that mirrored every [ColorScheme] role under different names
/// (a leftover from an early shadcn/ui-inspired token layout). That wrapper
/// was removed once the M3 migration closed out: it was a duplicate of
/// [ColorScheme] with no independent reason to exist, and every consumer
/// now reads M3-native roles straight from `Theme.of(context).colorScheme`.
/// [AppStatusColors] is the only piece that genuinely needs a custom
/// extension, because M3 has no built-in role for success/warning/info.
///
/// Access it anywhere with:
/// ```dart
/// final status = AppThemeExtension.of(context).status;
/// ```
///
/// Or via the convenience extension in `extensions.dart`:
/// ```dart
/// final status = context.statusColors;
/// ```
@immutable
final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({required this.status});

  /// The resolved status/semantic color tokens for the current brightness.
  final AppStatusColors status;

  // ── ThemeExtension contract ──────────────────────────────────────────────────

  @override
  AppThemeExtension copyWith({AppStatusColors? status}) {
    return AppThemeExtension(status: status ?? this.status);
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      status: AppStatusColors.lerp(status, other.status, t),
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
    return other is AppThemeExtension && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}
