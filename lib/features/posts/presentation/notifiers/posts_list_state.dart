import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';

/// View-state for the Posts list — wraps the fetched [posts] together with
/// pagination bookkeeping (whether another page exists, whether a
/// "load more" request is currently in flight, and the [Failure] from the
/// most recent failed "load more" attempt, if any).
///
/// ## Why a hand-written class, not Freezed
///
/// This project's Freezed mandate (see `flutter-arch-reviewer`'s
/// engineering principles) scopes to Domain/Data layer models — this is
/// Presentation-only view-state. Freezed's codegen machinery (deep
/// equality, generated `copyWith` mixins, union-type support) buys little
/// over a hand-written `copyWith` for four fields with no variants, and a
/// hand-written class means there's no `.freezed.dart` that has to be
/// regenerated to stay in sync — one less generated file to hand-mirror
/// in environments without the Dart SDK available to run `build_runner`.
///
/// ## Why `isLoadingMore` is separate from the notifier's own [AsyncValue]
///
/// The *first* page load should show a full-screen loading state — that's
/// already what wrapping this whole class in `AsyncValue<PostsListState>`
/// gives for free via [AsyncLoading]. A *subsequent* page load (triggered
/// by scrolling near the bottom) should keep the existing list on screen
/// with a small indicator appended at the bottom, not replace the screen
/// with a spinner and lose scroll position. That second case needs a flag
/// that lives *inside* the `AsyncData` payload, which is exactly what
/// [isLoadingMore] is for.
final class PostsListState {
  // Not `const` — [List.unmodifiable] is not a const expression.
  // The `const` keyword was removed intentionally (R-04, 27 Jun 2026):
  // wrapping `posts` in [List.unmodifiable] via the initializer list
  // enforces that callers cannot mutate the list directly (e.g. by
  // calling `.add()` / `.remove()` on a reference they hold to
  // `state.posts`). Without this, a mutation would silently change the
  // list in-memory with no Riverpod notification and no Freezed equality
  // enforcement — an especially real risk once Baseline's feature-level
  // notifiers start handling inline edits or reordering.
  //
  // Any caller that needs a mutable copy should use `List.of(state.posts)`
  // explicitly — the intent of "I'm making a mutable copy" is then visible
  // at the call site rather than being an accidental side-effect.
  PostsListState({
    required List<Post> posts,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  }) : posts = List.unmodifiable(posts);

  /// All posts loaded so far, in page order.
  final List<Post> posts;

  /// The last successfully loaded page number (1-indexed).
  final int currentPage;

  /// Whether a further page is believed to exist.
  ///
  /// Derived in the notifier from the json-server pagination contract:
  /// a page response shorter than the requested page size means the end
  /// of the list has been reached. Not derived here — this class doesn't
  /// know what page size was requested, only the result.
  final bool hasMore;

  /// True while a "load more" (next-page) request is in flight.
  final bool isLoadingMore;

  /// Set when the most recent "load more" attempt failed; `null`
  /// otherwise (including before any "load more" has ever been
  /// attempted). Surfaced by `posts_page.dart` as a transient SnackBar —
  /// the list itself is still perfectly valid, only the *next* page
  /// failed, so this deliberately doesn't replace [posts] with an error
  /// state the way the initial-load error path does.
  final Failure? loadMoreError;

  /// Returns a copy with [posts]/[currentPage]/[hasMore]/[isLoadingMore]
  /// updated as given, omitted fields preserved.
  ///
  /// Always clears [loadMoreError] as a side effect — every real call site
  /// (starting a new "load more" attempt, or a successful page load) is a
  /// case where a previous "load more" failure should no longer be shown.
  /// See [withLoadMoreError] for the one path (the failure branch) that
  /// needs to set it instead.
  PostsListState copyWith({
    List<Post>? posts,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PostsListState(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  /// Returns a copy with [loadMoreError] set to [error] (or cleared, if
  /// `null`), every other field preserved as-is.
  ///
  /// Kept separate from [copyWith] rather than as one more optional
  /// parameter there: `Failure?` being itself nullable makes "the caller
  /// didn't pass this" and "the caller explicitly wants it cleared to
  /// `null`" indistinguishable inside a single optional named parameter.
  /// Splitting the rarely-needed "set the error" transition into its own
  /// method sidesteps that ambiguity entirely instead of relying on every
  /// future call site remembering a sentinel-value convention.
  PostsListState withLoadMoreError(Failure? error) => PostsListState(
    posts: posts,
    currentPage: currentPage,
    hasMore: hasMore,
    isLoadingMore: isLoadingMore,
    loadMoreError: error,
  );
}
