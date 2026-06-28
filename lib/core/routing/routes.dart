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
  posts,

  /// Lives outside the [ShellRoute] — a detail page is a full-screen push,
  /// not a shell-level destination, so it intentionally has no matching
  /// entry in [AppPath]'s "shell children" group below.
  postDetail,
}

abstract final class AppPath {
  /// Shell children — always relative paths (no leading /).
  static const String home = '/';
  static const String settings = '/settings';
  static const String posts = '/posts';

  /// Relative child segment of [posts] — combined as `$posts/$postDetail`
  /// in [app_router.dart]. Kept relative so the id parameter only has to
  /// be spelled out once, at the point the route is actually registered.
  static const String postDetail = ':id';
}
