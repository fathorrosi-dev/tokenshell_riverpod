/// Border-radius tokens following shadcn/ui's --radius convention.
///
/// The [md] value (6.0 px) is the canonical base radius
/// (shadcn/ui --radius: 0.5rem translated to Flutter's logical pixels).
abstract final class RadiusTokens {
  /// 0 px — sharp corners.
  static const double none = 0;

  /// 4 px — subtle rounding, e.g. badges.
  static const double sm = 4;

  /// 6 px — default (shadcn/ui base --radius).
  static const double md = 6;

  /// 8 px — cards, dialogs.
  static const double lg = 8;

  /// 12 px — large panels.
  static const double xl = 12;

  /// 16 px — extra large containers.
  static const double x2l = 16;

  /// 24 px — 3xl.
  static const double x3l = 24;

  /// 9999 px — pill / circle (fully rounded).
  static const double full = 9999;
}
