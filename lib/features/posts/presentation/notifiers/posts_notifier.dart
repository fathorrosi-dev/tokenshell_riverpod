// dart run build_runner build --delete-conflicting-outputs
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/di/providers.dart';
import 'package:tokenshell_riverpod/features/posts/data/repositories/post_repository_impl.dart';
import 'package:tokenshell_riverpod/features/posts/data/sources/post_remote_source.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/domain/usecases/get_posts_usecase.dart';

part 'posts_notifier.g.dart';

// ── Infrastructure providers (posts-scoped) ───────────────────────────────────

/// Provides the [PostRemoteSource] Retrofit implementation.
@riverpod
PostRemoteSource postRemoteSource(Ref ref) {
  return PostRemoteSource(ref.watch(dioProvider));
}

/// Provides the [PostRepositoryImpl] wired with its dependencies.
@riverpod
PostRepositoryImpl postRepository(Ref ref) {
  return PostRepositoryImpl(
    remoteSource: ref.watch(postRemoteSourceProvider),
    connectivityGuard: () => requiresConnectivity(ref),
  );
}

/// Provides the [GetPostsUseCase] wired with the repository.
@riverpod
GetPostsUseCase getPostsUseCase(Ref ref) {
  return GetPostsUseCase(ref.watch(postRepositoryProvider));
}

// ── Posts AsyncNotifier ───────────────────────────────────────────────────────

/// Manages the async state of the posts list.
///
/// State lifecycle:
///   - [AsyncLoading] → while the use case is executing.
///   - [AsyncData]    → resolved [List<Post>] on success.
///   - [AsyncError]   → a typed [Failure] on any error path.
///
/// Consumers use `ref.watch(postsNotifierProvider)` for reactive UI and
/// `ref.read(postsNotifierProvider.notifier).refresh()` for manual refresh.
@riverpod
class PostsNotifier extends _$PostsNotifier {
  @override
  Future<List<Post>> build() async {
    return _fetchPosts();
  }

  /// Forces a fresh load from the remote source.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPosts);
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<List<Post>> _fetchPosts() async {
    final useCase = ref.read(getPostsUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => throw failure,
      (posts) => posts,
    );
  }
}
