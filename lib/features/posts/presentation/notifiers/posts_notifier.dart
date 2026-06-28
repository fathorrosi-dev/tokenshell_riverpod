// dart run build_runner build --delete-conflicting-outputs
import 'package:riverpod_annotation/riverpod_annotation.dart';
// UPDATED: was `presentation/providers/posts_providers.dart`.
// DI wiring has moved to the feature-level `di/` folder so Presentation
// never imports Data-layer types directly.
import 'package:tokenshell_riverpod/features/posts/di/posts_providers.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/notifiers/posts_list_state.dart';

part 'posts_notifier.g.dart';

// ── Posts AsyncNotifier ───────────────────────────────────────────────────────

/// Manages the async, paginated state of the posts list.
///
/// Infrastructure dependencies (PostRemoteSource, PostRepository,
/// GetPostsUseCase) are wired in the feature DI barrel (di/posts_providers.dart)
/// — this file is responsible only for state lifecycle and business actions.
///
/// State lifecycle:
///   - [AsyncLoading] → while the *first* page is loading (fresh `build()`
///     or [refresh]). Subsequent pages use [PostsListState.isLoadingMore]
///     instead — see that field's doc comment for why.
///   - [AsyncData]    → resolved [PostsListState] on success.
///   - [AsyncError]   → a typed `Failure` on any *first-page* error path.
///     A failed [loadMore] does NOT transition here — see [loadMore].
///
/// Consumers use `ref.watch(postsProvider)` for reactive UI,
/// `ref.read(postsProvider.notifier).refresh()` for pull-to-refresh / the
/// AppBar refresh button, and `ref.read(postsProvider.notifier).loadMore()`
/// when the list is scrolled near its end.
///
/// ## Why keepAlive (R-06, 27 Jun 2026)
///
/// Changed from `@riverpod` (autoDispose default) to
/// `@Riverpod(keepAlive: true)` so the paginated list state survives tab
/// navigation. With autoDispose, every switch to Settings or Home and back
/// would dispose this notifier — resetting to page 1 and discarding all
/// pages the user had already scrolled through. For a daily-use
/// productivity tool like Baseline, that's an unnecessary UX regression.
///
/// Tradeoff: keepAlive means the list stays in memory for the app's
/// lifetime. For stale-data mitigation, consider calling [refresh] on
/// screen re-focus via a GoRouter listener or AppLifecycleState observer
/// once real quota data is in place.
@Riverpod(keepAlive: true)
class PostsNotifier extends _$PostsNotifier {
  /// Posts per page. jsonplaceholder has exactly 100 posts; 20 keeps the
  /// list feeling continuously paginated (5 pages) without firing a
  /// network request on every other scroll tick. Maps to the `_page` /
  /// `_limit` query params in
  /// `features/posts/data/datasources/post_remote_source.dart`.
  static const int _pageSize = 20;

  @override
  Future<PostsListState> build() => _fetchPage(page: 1);

  /// Re-fetches from page 1, discarding any pages loaded via [loadMore].
  ///
  /// Used by pull-to-refresh and the AppBar refresh button — a refresh
  /// means "give me the current first page again," not "keep appending
  /// to what the user had already scrolled through." Showing a
  /// full-screen [AsyncLoading] here (rather than [PostsListState]'s own
  /// `isLoadingMore`) is deliberate for the same reason: this discards
  /// the existing list outright, so there is no "existing list" to keep
  /// visible underneath a small indicator the way [loadMore] has.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(page: 1));
  }

  /// Fetches the next page and appends it to the current list.
  ///
  /// No-ops if a load is already in flight or [PostsListState.hasMore] is
  /// false — guards against `posts_page.dart`'s scroll listener firing
  /// this more than once for the same approach-to-bottom (a real risk
  /// with scroll-position-based infinite scroll, not a hypothetical one)
  /// and against requesting a page past the end of the data.
  ///
  /// On failure, the existing list is deliberately kept on screen rather
  /// than replaced with a full-screen error: converting this whole
  /// notifier's state to [AsyncError] over a failed *next* page would
  /// throw away a list — and scroll position — the user was already
  /// looking at, for a request that's simply retryable. The failure is
  /// instead recorded on [PostsListState.loadMoreError] for
  /// `posts_page.dart` to surface as a transient SnackBar.
  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final useCase = ref.read(getPostsUseCaseProvider);
    final nextPage = current.currentPage + 1;
    final result = await useCase(page: nextPage, pageSize: _pageSize);

    state = result.fold(
      (failure) => AsyncData(
        current.copyWith(isLoadingMore: false).withLoadMoreError(failure),
      ),
      (posts) => AsyncData(
        current.copyWith(
          posts: [...current.posts, ...posts],
          currentPage: nextPage,
          // A page shorter than what was requested is the json-server
          // pagination contract's way of saying "that was the last one" —
          // there's no separate total-count field in this API's response
          // to check instead.
          hasMore: posts.length == _pageSize,
          isLoadingMore: false,
        ),
      ),
    );
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<PostsListState> _fetchPage({required int page}) async {
    final useCase = ref.read(getPostsUseCaseProvider);
    final result = await useCase(page: page, pageSize: _pageSize);

    // Bridges the Either-based Domain/Data error model to Riverpod's
    // throw-based AsyncValue model. This works cleanly specifically
    // because Failure implements Exception — posts_page.dart's
    // `error is Failure` check on the resulting AsyncError picks the
    // exact same instance back up, no information lost in the bridge.
    // Only used for the first page — [loadMore] handles its own
    // Either.fold without throwing, for the reasons documented there.
    return result.fold(
      (failure) => throw failure,
      (posts) => PostsListState(
        posts: posts,
        currentPage: page,
        hasMore: posts.length == _pageSize,
      ),
    );
  }
}
