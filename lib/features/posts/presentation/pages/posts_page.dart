import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/notifiers/posts_list_state.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/notifiers/posts_notifier.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/widgets/post_card.dart';
import 'package:tokenshell_riverpod/shared/widgets/app_state_view.dart';

/// Main posts list page — infinite-scroll paginated.
///
/// Handles three async states via [AsyncValue.when]:
///   - loading  → centred [CircularProgressIndicator] (first page only)
///   - error    → [AppStateView.error] with a retry button (first-page
///                failure only — a failed *next* page surfaces as a
///                SnackBar instead, see [_PostsPageState.build])
///   - data     → scrollable list of [PostCard] widgets, or
///                [AppStateView.empty] when the list is empty
///
/// The empty/error layouts used to be local `_EmptyView`/`_ErrorView`
/// widgets duplicated almost verbatim by `app_router.dart`'s
/// `_NotFoundPage` — both now share the single `AppStateView` widget.
///
/// A [ConsumerStatefulWidget], not [ConsumerWidget] — infinite scroll
/// needs a [ScrollController] to detect "user has scrolled near the
/// bottom," and that controller needs the standard `initState`/`dispose`
/// lifecycle a stateless widget doesn't have.
class PostsPage extends ConsumerStatefulWidget {
  const PostsPage({super.key});

  @override
  ConsumerState<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends ConsumerState<PostsPage> {
  /// How close to the bottom (in logical pixels) triggers the next page
  /// fetch. Far enough that the next page has a chance to arrive before
  /// the user actually reaches the end of the currently-loaded list —
  /// close enough that it doesn't fire while there's still most of a
  /// screen left to scroll.
  static const double _loadMoreThreshold = 200;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      // `loadMore()` already no-ops if a load is in flight or there's no
      // further page — see its doc comment. Safe to call unconditionally
      // on every scroll tick past the threshold, not just the first one.
      //
      // Wrapped in `unawaited`: this listener is a synchronous
      // `void Function()` callback handed to `ScrollController` — it
      // can't be `async`, so the `Future<void>` `loadMore()` returns has
      // nowhere to be awaited. `unawaited` documents that discarding it
      // is intentional (fire-and-forget is exactly what a scroll
      // listener needs) rather than an accidentally-forgotten `await`.
      unawaited(ref.read(postsProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Surfaces a failed *next* page as a transient SnackBar without
    // touching the rest of the screen — see [PostsListState.loadMoreError]
    // for why this doesn't go through the `error:` branch of
    // [AsyncValue.when] below.
    //
    // Fires exactly on the transition from "a load-more request was in
    // flight" to "that request just resulted in an error" — deliberately
    // NOT keyed on whether `loadMoreError`'s value changed. `Failure` is
    // a `@freezed` class with structural equality, so two failures in a
    // row carrying the identical message (e.g. the same `NetworkFailure`
    // default text, twice) would compare `==` even though they're two
    // separate occurrences — keying on value-change would silently
    // swallow the second SnackBar. Keying on the `isLoadingMore`
    // transition instead fires once per actual `loadMore()` attempt,
    // regardless of what the resulting Failure happens to equal.
    //
    // Lives at ConsumerState level (not inside the Consumer below) so
    // it has access to `context` for ScaffoldMessenger — ref.listen
    // does not cause a rebuild by itself.
    ref.listen<AsyncValue<PostsListState>>(postsProvider, (previous, next) {
      final wasLoadingMore = previous?.asData?.value.isLoadingMore ?? false;
      final error = next.asData?.value.loadMoreError;
      if (!wasLoadingMore || error == null) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    });

    return Scaffold(
      backgroundColor: colors.background,
      // AppBar does NOT watch postsProvider — it will not rebuild when
      // pagination state changes (isLoadingMore toggle, page appended).
      // Only the body Consumer below rebuilds on list state changes.
      // (R-11, 27 Jun 2026 — production readiness audit)
      appBar: AppBar(
        title: const Text(AppStrings.postsAppBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: AppStrings.postsRefreshTooltip,
            // ref.read here is intentional — the button action fires once
            // on tap, not reactively; it doesn't need a watch subscription.
            onPressed: () => ref.read(postsProvider.notifier).refresh(),
          ),
          const SizedBox(width: SpacingTokens.sm),
        ],
      ),
      // Consumer isolates postsProvider rebuilds to the body only.
      // The Scaffold frame (background color) and AppBar above are stable
      // across all pagination events and don't need to rebuild.
      body: Consumer(
        builder: (context, watchRef, _) {
          final postsAsync = watchRef.watch(postsProvider);
          final bodyColors = context.colors;

          return postsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => AppStateView.error(
              message: error is Failure ? error.message : error.toString(),
              iconColor: bodyColors.destructive,
              onRetry: () => watchRef.read(postsProvider.notifier).refresh(),
            ),
            data: (listState) => listState.posts.isEmpty
                ? AppStateView.empty(title: AppStrings.postsEmptyTitle)
                : ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.pagePadding.horizontal / 2,
                      vertical: SpacingTokens.xl,
                    ),
                    // +1 footer row while a next page is loading — the
                    // trailing spinner that tells the user more is coming.
                    // Not shown just because `hasMore` is true: only an
                    // *active* load gets a visible indicator, otherwise the
                    // list would show a perpetual spinner under the very
                    // last page.
                    itemCount:
                        listState.posts.length +
                        (listState.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: SpacingTokens.md),
                    itemBuilder: (context, index) {
                      if (index >= listState.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SpacingTokens.xl,
                          ),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return PostCard(post: listState.posts[index]);
                    },
                  ),
          );
        },
      ),
    );
  }
}
