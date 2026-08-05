/// Material 3 shape scale — per-category corner radii (m3.material.io/styles/shape).
///
/// Replaces the previous single-base shadcn/ui `--radius` convention with the
/// M3 shape categories. Values are the M3 baseline dp tokens:
///
/// | Category    | Value | Typical M3 families (guidance untuk Wave 1 builders) |
/// |-------------|-------|------------------------------------------------------|
/// | none        | 0     | full-bleed / kasus khusus                            |
/// | extraSmall  | 4     | text fields, small components                         |
/// | small       | 8     | chips, menus (small interactive)                      |
/// | medium      | 12    | cards, dialogs kecil (default container)              |
/// | large       | 16    | large cards, bottom sheets (top corners), drawer      |
/// | extraLarge  | 28    | dialogs (M3 baseline), FAB extended besar             |
/// | full        | pill  | buttons, FAB, switch track, badges pill               |
abstract final class RadiusTokens {
  /// 0 px — sharp corners (M3 "none").
  static const double none = 0;

  /// 4 px — M3 extraSmall.
  static const double extraSmall = 4;

  /// 8 px — M3 small.
  static const double small = 8;

  /// 12 px — M3 medium.
  static const double medium = 12;

  /// 16 px — M3 large.
  static const double large = 16;

  /// 28 px — M3 extraLarge.
  static const double extraLarge = 28;

  /// 9999 px — pill / circle (M3 "full").
  static const double full = 9999;
}
