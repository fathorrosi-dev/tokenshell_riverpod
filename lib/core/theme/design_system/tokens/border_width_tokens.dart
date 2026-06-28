import 'package:flutter/material.dart';

/// Border width tokens following shadcn/ui's minimal border convention.
///
/// All values are in logical pixels. Use these constants instead of raw
/// 1 / 1.5 / 2 literals in [BorderSide], [OutlineInputBorder], etc.
abstract final class BorderWidthTokens {
  /// 0.5 px — hairline; use for extremely subtle separators.
  static const double hairline = 0.5;

  /// 1 px — default border (card outlines, list separators, default input).
  static const double sm = 1;

  /// 1.5 px — form control borders (checkbox, radio).
  static const double md = 1.5;

  /// 2 px — focused / active state borders (focus ring, focused input, focused outline button).
  static const double lg = 2;
}
