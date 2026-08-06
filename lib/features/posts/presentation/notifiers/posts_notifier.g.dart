// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(PostsNotifier)
final postsProvider = PostsNotifierProvider._();

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
final class PostsNotifierProvider
    extends $AsyncNotifierProvider<PostsNotifier, PostsListState> {
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
  PostsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsNotifierHash();

  @$internal
  @override
  PostsNotifier create() => PostsNotifier();
}

String _$postsNotifierHash() => r'24cf06e8e68192bfa644137ea0fe147053e58515';

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

abstract class _$PostsNotifier extends $AsyncNotifier<PostsListState> {
  FutureOr<PostsListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostsListState>, PostsListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostsListState>, PostsListState>,
              AsyncValue<PostsListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
