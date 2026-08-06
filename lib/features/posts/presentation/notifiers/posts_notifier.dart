// dart run build_runner build --delete-conflicting-outputs
import 'package:riverpod_annotation/riverpod_annotation.dart';
// UPDATED: was `presentation/providers/posts_providers.dart`.
// DI wiring has moved to the feature-level `di/` folder so Presentation
// never imports Data-layer types directly.
import 'package:tokenshell_riverpod/features/posts/di/posts_providers.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
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
/// productivity tool like TokenShell, that's an unnecessary UX regression.
///
/// Tradeoff: keepAlive means the list stays in memory for the app's
/// lifetime. For stale-data mitigation, consider calling [refresh] on
/// screen re-focus via a GoRouter listener or AppLifecycleState observer
/// once real quota data is in place. For unbounded *growth* mitigation,
/// see [_maxRetainedPages] — keepAlive alone only answers "when is this
/// disposed," not "how large is it allowed to get while alive."
@Riverpod(keepAlive: true)
class PostsNotifier extends _$PostsNotifier {
  /// Posts per page. jsonplaceholder has exactly 100 posts; 20 keeps the
  /// list feeling continuously paginated (5 pages) without firing a
  /// network request on every other scroll tick. Maps to the `_page` /
  /// `_limit` query params in
  /// `features/posts/data/datasources/post_remote_source.dart`.
  static const int _pageSize = 20;

  /// Maximum number of most-recently-loaded pages kept in
  /// [PostsListState.posts] at once (R-18, 3 Jul 2026 — production
  /// readiness audit, Pillar 1).
  ///
  /// [PostsNotifier] is `keepAlive` (R-06) specifically so pagination
  /// state survives tab switches — but keepAlive only controls *when*
  /// this notifier is disposed, not how large its state is allowed to
  /// grow while alive. Before this constant existed, [loadMore] only
  /// ever appended pages, with no upper bound: harmless for
  /// jsonplaceholder's 100-post ceiling (~2000 [Post] objects
  /// worst-case), but this notifier is written as the reference pattern
  /// every future paginated feature in TokenShell is expected to copy —
  /// and a real backend rarely caps itself at 100 records. Without a
  /// retention window, that copy-paste would silently inherit an
  /// unbounded memory-growth footgun the day it's pointed at a real API.
  ///
  /// Deliberately set higher than this app's own 5-page maximum (100
  /// posts ÷ 20 per page) rather than tuned to it: the point is a
  /// general-purpose safety ceiling for whatever feature reuses this
  /// pattern next, not a value that happens to make eviction fire in
  /// *this* demo. jsonplaceholder's own list never actually reaches 10
  /// retained pages, so this ships with zero visible behavior change to
  /// TokenShell's current Posts screen — the ceiling exists for the next
  /// feature that copies this notifier against a larger dataset.
  ///
  /// ## UX tradeoff (read before changing this)
  ///
  /// Eviction means a user who scrolls back up past the retained window
  /// no longer sees posts from pages that were evicted — the list
  /// starts at whatever [PostsListState.oldestRetainedPage] currently
  /// is, not page 1. That's a deliberate memory-vs-completeness
  /// tradeoff, not a bug: most production infinite-scroll feeds already
  /// behave this way once a session runs long enough. A feature that
  /// genuinely needs full scroll-back history kept in memory (not just
  /// re-fetchable from the network) should override this constant to a
  /// value comfortably above its realistic max dataset size — not
  /// remove the windowing mechanism itself.
  static const int _maxRetainedPages = 10;

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
        _appendPageWithRetention(
          current: current,
          newPosts: posts,
          nextPage: nextPage,
        ),
      ),
    );
  }

  // ── Private ────────────────────────────────────────────────────────────────

  /// Appends [newPosts] (the just-fetched [nextPage]) to [current], then
  /// evicts the oldest retained page(s) if the result would exceed
  /// [_maxRetainedPages] — see that constant's doc comment for the full
  /// memory-growth rationale and UX tradeoff.
  ///
  /// Evicting by `posts.sublist(_pageSize)` — dropping exactly one
  /// page-size's worth of items from the front — relies on an invariant
  /// that's worth spelling out: every page eligible for eviction here is
  /// a page that was *not* the most recently loaded one, and [loadMore]
  /// only ever runs again while [PostsListState.hasMore] is still true,
  /// which the notifier itself derives from "the last page came back
  /// exactly [_pageSize] long" (see the `hasMore` assignment below and in
  /// [_fetchPage]). So by construction, no page still eligible for a
  /// future eviction can be short — only the newest, not-yet-evictable
  /// page ever can be. If [_pageSize] ever became page-dependent (a
  /// backend with variable page sizes), this method would need each
  /// evicted page's own length tracked instead of assuming [_pageSize]
  /// uniformly.
  PostsListState _appendPageWithRetention({
    required PostsListState current,
    required List<Post> newPosts,
    required int nextPage,
  }) {
    var posts = [...current.posts, ...newPosts];
    var oldestRetainedPage = current.oldestRetainedPage;

    // A `while`, not a single `if`: normal one-page-at-a-time growth from
    // `loadMore()` only ever needs at most one eviction pass, but this
    // stays correct even if `_maxRetainedPages` were ever reconfigured to
    // something smaller than the number of pages a long-lived keepAlive
    // session had already accumulated.
    while (nextPage - oldestRetainedPage + 1 > _maxRetainedPages) {
      posts = posts.sublist(_pageSize);
      oldestRetainedPage++;
    }

    return current.copyWith(
      posts: posts,
      currentPage: nextPage,
      // A page shorter than what was requested is the json-server
      // pagination contract's way of saying "that was the last one" —
      // there's no separate total-count field in this API's response
      // to check instead.
      hasMore: newPosts.length == _pageSize,
      isLoadingMore: false,
      oldestRetainedPage: oldestRetainedPage,
    );
  }

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
