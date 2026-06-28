import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/core/routing/shell_feature.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/pages/post_detail_page.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/pages/posts_page.dart';

/// Shell-level routes for the Posts feature (list page).
///
/// Spread into [ShellRoute.routes] in [app_router.dart]. The list page
/// lives inside the shell so bottom nav / rail is visible underneath it.
///
/// The detail page is intentionally NOT here — see [postsStandaloneRoutes].
List<RouteBase> get postsShellRoutes => [
  GoRoute(
    path: AppPath.posts,
    name: AppRoute.posts.name,
    pageBuilder: (context, state) => const NoTransitionPage(
      child: PostsPage(),
    ),
  ),
];

/// This feature's single entry in `core/routing/feature_registry.dart`'s
/// `shellFeatures` list — bundles [postsShellRoutes] (the list page only;
/// [postsStandaloneRoutes] stays registered separately) with this
/// feature's nav appearance so both stay in sync from one declaration.
ShellFeature get postsShellFeature => ShellFeature(
  destination: const NavDestination(
    route: AppRoute.posts,
    path: AppPath.posts,
    label: AppStrings.navPosts,
    icon: Icons.article_outlined,
    selectedIcon: Icons.article_rounded,
  ),
  routes: postsShellRoutes,
);

/// Top-level (standalone) routes for the Posts feature (detail page).
///
/// Registered outside the [ShellRoute] so the detail page is a
/// full-screen push — no bottom nav / rail visible underneath.
/// Core routing spreads this list at the same level as the shell,
/// not inside it.
///
/// Path: `/posts/:id` — the `:id` segment is parsed back into an
/// [int] at build time. An invalid (non-numeric) `id` throws a
/// [FormatException] which go_router catches and routes to [_NotFoundPage].
List<RouteBase> get postsStandaloneRoutes => [
  GoRoute(
    path: '${AppPath.posts}/${AppPath.postDetail}',
    name: AppRoute.postDetail.name,
    builder: (context, state) {
      final id = int.parse(state.pathParameters['id']!);
      return PostDetailPage(postId: id);
    },
  ),
];
