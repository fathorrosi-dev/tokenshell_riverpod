// dart run build_runner build --delete-conflicting-outputs
import 'package:riverpod_annotation/riverpod_annotation.dart';
// UPDATED: was `presentation/providers/posts_providers.dart`.
// DI wiring has moved to the feature-level `di/` folder so Presentation
// never imports Data-layer types directly.
import 'package:tokenshell_riverpod/features/posts/di/posts_providers.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/notifiers/posts_notifier.dart';

part 'post_detail_notifier.g.dart';

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
@riverpod
Future<Post> postDetail(Ref ref, int id) async {
  final cachedPosts = ref.read(postsProvider).asData?.value.posts;
  if (cachedPosts != null) {
    for (final post in cachedPosts) {
      if (post.id == id) return post;
    }
  }

  // Cache miss — e.g. a deep link straight into the detail page, or the
  // list hasn't loaded this post yet. Fall back to the network exactly as
  // before.
  //
  // Changed from ref.read to ref.watch (R-10, 27 Jun 2026): both
  // getPostByIdUseCaseProvider and this provider are autoDispose, but
  // ref.read does not add a subscription — so the use case provider was
  // not kept alive during the async fetch. ref.watch adds a subscription
  // that holds getPostByIdUseCaseProvider alive for the duration of this
  // provider's lifetime (i.e. as long as PostDetailPage is in the tree),
  // avoiding the race condition where the use case provider gets disposed
  // between the read and the actual await.
  final useCase = ref.watch(getPostByIdUseCaseProvider);
  final result = await useCase(id);

  // Same Either → AsyncValue bridge as `PostsNotifier._fetchPosts` — see
  // that file for the full rationale. Kept identical on purpose so the
  // two error-handling paths in this feature don't diverge.
  return result.fold(
    (failure) => throw failure,
    (post) => post,
  );
}
