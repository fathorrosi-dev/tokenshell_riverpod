// dart run build_runner build --delete-conflicting-outputs
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tokenshell_riverpod/core/di/providers.dart';
import 'package:tokenshell_riverpod/features/posts/data/datasources/post_remote_source.dart';
import 'package:tokenshell_riverpod/features/posts/data/repositories/post_repository_impl.dart';
import 'package:tokenshell_riverpod/features/posts/domain/repositories/post_repository.dart';
import 'package:tokenshell_riverpod/features/posts/domain/usecases/get_post_by_id_usecase.dart';
import 'package:tokenshell_riverpod/features/posts/domain/usecases/get_posts_usecase.dart';

part 'posts_providers.g.dart';

// ── Posts feature — Infrastructure DI ─────────────────────────────────────────
//
// MOVED: was at `presentation/providers/posts_providers.dart`.
//
// Infrastructure wiring belongs here (feature DI barrel), not inside the
// Presentation layer. Keeping DI in `presentation/` made Presentation aware
// of Data-layer types (PostRemoteSource, PostRepositoryImpl) — a layer
// boundary violation that would propagate to every future feature.
//
// The `di/` folder is the Composition Root for this feature:
//   • Presentation (notifiers, pages, widgets) depends on `di/` for providers.
//   • `di/` depends on Data + Domain layer types to wire them up.
//   • Presentation never imports from Data directly — only through `di/`.
//
// Everything else about this file is unchanged from the original.
//
// Note: after running `build_runner build`, the generated file lands at
// `features/posts/di/posts_providers.g.dart` (alongside this file).
// Delete the old `presentation/providers/` folder once the generated
// file at the new location is confirmed.

/// Provides the [PostRemoteSource] Retrofit implementation.
///
/// Scoped to the Posts feature — wired with the app's main [dioProvider]
/// (Auth + Retry + Logger interceptors included).
///
/// Stays `autoDispose` (the `@riverpod` default): unlike
/// [postRepositoryProvider] below, nothing here captures this provider's
/// own [Ref] into a closure that outlives the build call, so there is no
/// Ref-safety reason to pin it alive. It is also transitively kept alive
/// for free anyway, for as long as [postRepositoryProvider] — which is
/// `keepAlive` — holds its `ref.watch` subscription on it.
@riverpod
PostRemoteSource postRemoteSource(Ref ref) {
  return PostRemoteSource(ref.watch(dioProvider));
}

/// Provides the [PostRepository] wired with its dependencies.
///
/// Returns the abstract [PostRepository] interface rather than
/// [PostRepositoryImpl] — any consumer (use cases, other providers)
/// depends only on the contract. Tests can override this provider with
/// any [PostRepository] implementation without touching anything downstream.
///
/// ## Why `keepAlive: true` — not just a performance choice
///
/// `connectivityGuard: () => requiresConnectivity(ref)` closes over this
/// provider's *own* [Ref] and stores it inside the returned
/// [PostRepositoryImpl] — a value that outlives this build call. Per the
/// Ref-safety contract documented on [ConnectivityGuard], an `autoDispose`
/// provider doing this is only safe by accident of call ordering: every
/// current call site reads `ref` synchronously before the first `await`,
/// but nothing stops a future change from breaking that invariant and
/// triggering "Cannot use a Ref after it has been disposed." at runtime.
///
/// `keepAlive: true` removes the entire risk class instead of relying on
/// callers to preserve that ordering forever: the captured `ref` stays
/// valid for the rest of the app's lifetime, exactly like [dioProvider]
/// and [failureMapperProvider] that this repository itself depends on.
/// The cost is identical to theirs too — one stateless, cheap-to-hold
/// coordination object kept around instead of rebuilt on every list
/// refresh.
@Riverpod(keepAlive: true)
PostRepository postRepository(Ref ref) {
  return PostRepositoryImpl(
    remoteSource: ref.watch(postRemoteSourceProvider),
    connectivityGuard: () => requiresConnectivity(ref),
    failureMapper: ref.watch(failureMapperProvider),
  );
}

/// Provides the [GetPostsUseCase] wired with the posts repository.
@riverpod
GetPostsUseCase getPostsUseCase(Ref ref) {
  return GetPostsUseCase(ref.watch(postRepositoryProvider));
}

/// Provides the [GetPostByIdUseCase] wired with the posts repository.
///
/// Mirrors [getPostsUseCaseProvider] above — same repository dependency,
/// same scoping (feature-level, autoDispose). Added so `getPostById` on
/// the repository finally has a matching use case, consistent with the
/// Repository → UseCase → Notifier convention `getPosts` already follows.
@riverpod
GetPostByIdUseCase getPostByIdUseCase(Ref ref) {
  return GetPostByIdUseCase(ref.watch(postRepositoryProvider));
}
