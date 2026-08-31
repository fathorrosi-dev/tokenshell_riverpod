import 'package:material_ui/material_ui.dart';

/// Icon size tokens built on a progressive scale aligned with the 4 px base grid.
///
/// Use these constants instead of raw numeric literals everywhere an icon size
/// is set — in [IconThemeData], [NavigationBarThemeData], [Icon] widget, etc.
abstract final class IconSizeTokens {
  /// 14 px — small inline icons (trailing chevrons, dense list leading icons).
  static const double xs = 14;

  /// 16 px — compact UI icons (chip leading, badge icons, dense controls).
  static const double sm = 16;

  /// 20 px — default UI icon size (app bar, list tiles, action buttons).
  static const double md = 20;

  /// 22 px — navigation bar icons (slightly larger for touch-target comfort).
  static const double lg = 22;

  /// 24 px — prominent icons (hero sections, FAB).
  static const double xl = 24;

  /// 28 px — large decorative icons.
  static const double x2l = 28;

  /// 32 px — extra-large / illustrative icons.
  static const double x3l = 32;

  /// 48 px — full-bleed empty/error state icons (see [AppStateView]).
  ///
  /// Added during the 01 Jul 2026 production-readiness audit: this exact
  /// size was already in use as a raw `48` literal in `app_state_view.dart`
  /// — added here (rather than resizing to the nearest existing step) to
  /// close the token-discipline gap without an uncommunicated visual change.
  static const double x4l = 48;
}
