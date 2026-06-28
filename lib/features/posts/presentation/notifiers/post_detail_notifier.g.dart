// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a single post by [id] for the detail page.
///
/// A plain `@riverpod` function provider (not a class notifier) — the
/// detail page only ever needs a one-shot fetch with the standard
/// loading/data/error lifecycle a function provider already gives for
/// free. There's no extra business action here that would justify a full
/// notifier the way `PostsNotifier.refresh()` does for the list; the
/// equivalent of "refresh" for this provider is simply
/// `ref.invalidate(postDetailProvider(id))` from the widget.
///
/// Before hitting the network, this checks whether [id] is already
/// sitting in [postsProvider]'s currently-loaded pages — the
/// overwhelmingly common path into this page is tapping a [PostCard]
/// that came from a page the user has actually scrolled to, so the data
/// is almost always already in memory. Since the list is paginated, this
/// is a cache of *however many pages have loaded so far*, not the full
/// 100 posts — a deep link straight to a post past the loaded pages
/// falls through to the network fetch below exactly like any other
/// cache miss.
/// Deliberately `ref.read`, not `ref.watch`: this should stay a one-shot
/// peek, not a standing dependency that re-runs this fetch every time the
/// unrelated list refreshes.
///
/// `id` becomes the provider's family argument automatically — call sites
/// use `ref.watch(postDetailProvider(id))`.

@ProviderFor(postDetail)
final postDetailProvider = PostDetailFamily._();

/// Fetches a single post by [id] for the detail page.
///
/// A plain `@riverpod` function provider (not a class notifier) — the
/// detail page only ever needs a one-shot fetch with the standard
/// loading/data/error lifecycle a function provider already gives for
/// free. There's no extra business action here that would justify a full
/// notifier the way `PostsNotifier.refresh()` does for the list; the
/// equivalent of "refresh" for this provider is simply
/// `ref.invalidate(postDetailProvider(id))` from the widget.
///
/// Before hitting the network, this checks whether [id] is already
/// sitting in [postsProvider]'s currently-loaded pages — the
/// overwhelmingly common path into this page is tapping a [PostCard]
/// that came from a page the user has actually scrolled to, so the data
/// is almost always already in memory. Since the list is paginated, this
/// is a cache of *however many pages have loaded so far*, not the full
/// 100 posts — a deep link straight to a post past the loaded pages
/// falls through to the network fetch below exactly like any other
/// cache miss.
/// Deliberately `ref.read`, not `ref.watch`: this should stay a one-shot
/// peek, not a standing dependency that re-runs this fetch every time the
/// unrelated list refreshes.
///
/// `id` becomes the provider's family argument automatically — call sites
/// use `ref.watch(postDetailProvider(id))`.

final class PostDetailProvider
    extends $FunctionalProvider<AsyncValue<Post>, Post, FutureOr<Post>>
    with $FutureModifier<Post>, $FutureProvider<Post> {
  /// Fetches a single post by [id] for the detail page.
  ///
  /// A plain `@riverpod` function provider (not a class notifier) — the
  /// detail page only ever needs a one-shot fetch with the standard
  /// loading/data/error lifecycle a function provider already gives for
  /// free. There's no extra business action here that would justify a full
  /// notifier the way `PostsNotifier.refresh()` does for the list; the
  /// equivalent of "refresh" for this provider is simply
  /// `ref.invalidate(postDetailProvider(id))` from the widget.
  ///
  /// Before hitting the network, this checks whether [id] is already
  /// sitting in [postsProvider]'s currently-loaded pages — the
  /// overwhelmingly common path into this page is tapping a [PostCard]
  /// that came from a page the user has actually scrolled to, so the data
  /// is almost always already in memory. Since the list is paginated, this
  /// is a cache of *however many pages have loaded so far*, not the full
  /// 100 posts — a deep link straight to a post past the loaded pages
  /// falls through to the network fetch below exactly like any other
  /// cache miss.
  /// Deliberately `ref.read`, not `ref.watch`: this should stay a one-shot
  /// peek, not a standing dependency that re-runs this fetch every time the
  /// unrelated list refreshes.
  ///
  /// `id` becomes the provider's family argument automatically — call sites
  /// use `ref.watch(postDetailProvider(id))`.
  PostDetailProvider._({
    required PostDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailHash();

  @override
  String toString() {
    return r'postDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Post> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Post> create(Ref ref) {
    final argument = this.argument as int;
    return postDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailHash() => r'2c5351b59196782dd8a614d2ea1d39c31e46ae11';

/// Fetches a single post by [id] for the detail page.
///
/// A plain `@riverpod` function provider (not a class notifier) — the
/// detail page only ever needs a one-shot fetch with the standard
/// loading/data/error lifecycle a function provider already gives for
/// free. There's no extra business action here that would justify a full
/// notifier the way `PostsNotifier.refresh()` does for the list; the
/// equivalent of "refresh" for this provider is simply
/// `ref.invalidate(postDetailProvider(id))` from the widget.
///
/// Before hitting the network, this checks whether [id] is already
/// sitting in [postsProvider]'s currently-loaded pages — the
/// overwhelmingly common path into this page is tapping a [PostCard]
/// that came from a page the user has actually scrolled to, so the data
/// is almost always already in memory. Since the list is paginated, this
/// is a cache of *however many pages have loaded so far*, not the full
/// 100 posts — a deep link straight to a post past the loaded pages
/// falls through to the network fetch below exactly like any other
/// cache miss.
/// Deliberately `ref.read`, not `ref.watch`: this should stay a one-shot
/// peek, not a standing dependency that re-runs this fetch every time the
/// unrelated list refreshes.
///
/// `id` becomes the provider's family argument automatically — call sites
/// use `ref.watch(postDetailProvider(id))`.

final class PostDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Post>, int> {
  PostDetailFamily._()
    : super(
        retry: null,
        name: r'postDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a single post by [id] for the detail page.
  ///
  /// A plain `@riverpod` function provider (not a class notifier) — the
  /// detail page only ever needs a one-shot fetch with the standard
  /// loading/data/error lifecycle a function provider already gives for
  /// free. There's no extra business action here that would justify a full
  /// notifier the way `PostsNotifier.refresh()` does for the list; the
  /// equivalent of "refresh" for this provider is simply
  /// `ref.invalidate(postDetailProvider(id))` from the widget.
  ///
  /// Before hitting the network, this checks whether [id] is already
  /// sitting in [postsProvider]'s currently-loaded pages — the
  /// overwhelmingly common path into this page is tapping a [PostCard]
  /// that came from a page the user has actually scrolled to, so the data
  /// is almost always already in memory. Since the list is paginated, this
  /// is a cache of *however many pages have loaded so far*, not the full
  /// 100 posts — a deep link straight to a post past the loaded pages
  /// falls through to the network fetch below exactly like any other
  /// cache miss.
  /// Deliberately `ref.read`, not `ref.watch`: this should stay a one-shot
  /// peek, not a standing dependency that re-runs this fetch every time the
  /// unrelated list refreshes.
  ///
  /// `id` becomes the provider's family argument automatically — call sites
  /// use `ref.watch(postDetailProvider(id))`.

  PostDetailProvider call(int id) =>
      PostDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'postDetailProvider';
}
