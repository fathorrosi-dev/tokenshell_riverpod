// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [PostRemoteSource] Retrofit implementation.

@ProviderFor(postRemoteSource)
final postRemoteSourceProvider = PostRemoteSourceProvider._();

/// Provides the [PostRemoteSource] Retrofit implementation.

final class PostRemoteSourceProvider
    extends
        $FunctionalProvider<
          PostRemoteSource,
          PostRemoteSource,
          PostRemoteSource
        >
    with $Provider<PostRemoteSource> {
  /// Provides the [PostRemoteSource] Retrofit implementation.
  PostRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRemoteSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<PostRemoteSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostRemoteSource create(Ref ref) {
    return postRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRemoteSource>(value),
    );
  }
}

String _$postRemoteSourceHash() => r'7247697317ef6e383681027ecf82b2bf7a41cd4d';

/// Provides the [PostRepositoryImpl] wired with its dependencies.

@ProviderFor(postRepository)
final postRepositoryProvider = PostRepositoryProvider._();

/// Provides the [PostRepositoryImpl] wired with its dependencies.

final class PostRepositoryProvider
    extends
        $FunctionalProvider<
          PostRepositoryImpl,
          PostRepositoryImpl,
          PostRepositoryImpl
        >
    with $Provider<PostRepositoryImpl> {
  /// Provides the [PostRepositoryImpl] wired with its dependencies.
  PostRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRepositoryHash();

  @$internal
  @override
  $ProviderElement<PostRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PostRepositoryImpl create(Ref ref) {
    return postRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRepositoryImpl>(value),
    );
  }
}

String _$postRepositoryHash() => r'4f1cc8cdcc520ad7592ca534f9f087ca9b6d95d3';

/// Provides the [GetPostsUseCase] wired with the repository.

@ProviderFor(getPostsUseCase)
final getPostsUseCaseProvider = GetPostsUseCaseProvider._();

/// Provides the [GetPostsUseCase] wired with the repository.

final class GetPostsUseCaseProvider
    extends
        $FunctionalProvider<GetPostsUseCase, GetPostsUseCase, GetPostsUseCase>
    with $Provider<GetPostsUseCase> {
  /// Provides the [GetPostsUseCase] wired with the repository.
  GetPostsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPostsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPostsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPostsUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetPostsUseCase create(Ref ref) {
    return getPostsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPostsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPostsUseCase>(value),
    );
  }
}

String _$getPostsUseCaseHash() => r'34e794f751dbe2b7d32d1178b530a1cd729a3f27';

/// Manages the async state of the posts list.
///
/// State lifecycle:
///   - [AsyncLoading] → while the use case is executing.
///   - [AsyncData]    → resolved [List<Post>] on success.
///   - [AsyncError]   → a typed [Failure] on any error path.
///
/// Consumers use `ref.watch(postsNotifierProvider)` for reactive UI and
/// `ref.read(postsNotifierProvider.notifier).refresh()` for manual refresh.

@ProviderFor(PostsNotifier)
final postsProvider = PostsNotifierProvider._();

/// Manages the async state of the posts list.
///
/// State lifecycle:
///   - [AsyncLoading] → while the use case is executing.
///   - [AsyncData]    → resolved [List<Post>] on success.
///   - [AsyncError]   → a typed [Failure] on any error path.
///
/// Consumers use `ref.watch(postsNotifierProvider)` for reactive UI and
/// `ref.read(postsNotifierProvider.notifier).refresh()` for manual refresh.
final class PostsNotifierProvider
    extends $AsyncNotifierProvider<PostsNotifier, List<Post>> {
  /// Manages the async state of the posts list.
  ///
  /// State lifecycle:
  ///   - [AsyncLoading] → while the use case is executing.
  ///   - [AsyncData]    → resolved [List<Post>] on success.
  ///   - [AsyncError]   → a typed [Failure] on any error path.
  ///
  /// Consumers use `ref.watch(postsNotifierProvider)` for reactive UI and
  /// `ref.read(postsNotifierProvider.notifier).refresh()` for manual refresh.
  PostsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsNotifierHash();

  @$internal
  @override
  PostsNotifier create() => PostsNotifier();
}

String _$postsNotifierHash() => r'4b3373a2b1cee9ddb51eaa1e62370bdd235618fa';

/// Manages the async state of the posts list.
///
/// State lifecycle:
///   - [AsyncLoading] → while the use case is executing.
///   - [AsyncData]    → resolved [List<Post>] on success.
///   - [AsyncError]   → a typed [Failure] on any error path.
///
/// Consumers use `ref.watch(postsNotifierProvider)` for reactive UI and
/// `ref.read(postsNotifierProvider.notifier).refresh()` for manual refresh.

abstract class _$PostsNotifier extends $AsyncNotifier<List<Post>> {
  FutureOr<List<Post>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
