import 'package:flutter/painting.dart';

/// Box-shadow tokens inspired by shadcn/ui's subtle elevation system.
///
/// All shadow colors use semi-transparent black; no colored shadows.
/// Each tier is [static const] and can be used directly in [BoxDecoration].
abstract final class ShadowTokens {
  /// No shadow — completely flat.
  static const List<BoxShadow> none = [];

  /// Extra-small shadow — barely perceptible lift.
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A000000), // black 4 %
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Small shadow — for input fields and subtle cards.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 4,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000), // black 4 %
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Medium shadow — default for cards, dropdowns, and popovers.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000), // black 8 %
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 3,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];

  /// Large shadow — for modals and floating overlays.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000), // black 10 %
      blurRadius: 16,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 6,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  /// Extra-large shadow — for prominent panels.
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1A000000), // black 10 %
      blurRadius: 24,
      spreadRadius: -8,
      offset: Offset(0, 20),
    ),
    BoxShadow(
      color: Color(0x0F000000), // black 6 %
      blurRadius: 8,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  /// 2xl shadow — maximum depth, use sparingly.
  static const List<BoxShadow> x2l = [
    BoxShadow(
      color: Color(0x26000000), // black 15 %
      blurRadius: 48,
      spreadRadius: -12,
      offset: Offset(0, 25),
    ),
  ];
}
