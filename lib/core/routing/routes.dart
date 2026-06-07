import 'package:go_router/go_router.dart';

/// Typed route name and path constants.
///
/// Convention:
///   - [AppRoute] enum  → canonical route *names* used by go_router's `name:`.
///   - [AppPath]  class → raw path segments used by go_router's `path:`.
///
/// To add a new feature route:
///   1. Add an entry to [AppRoute].
///   2. Add the path constant to [AppPath].
// ignore: comment_references
///   3. Add a [GoRoute] / [ShellRoute] in [app_router.dart].
///   No other core file needs modification.
enum AppRoute {
  home,
  settings,
}

abstract final class AppPath {
  /// Shell children — always relative paths (no leading /).
  static const String home = '/';
  static const String settings = '/settings';
}
