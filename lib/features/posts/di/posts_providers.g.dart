// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(postRemoteSource)
final postRemoteSourceProvider = PostRemoteSourceProvider._();

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

final class PostRemoteSourceProvider
    extends
        $FunctionalProvider<
          PostRemoteSource,
          PostRemoteSource,
          PostRemoteSource
        >
    with $Provider<PostRemoteSource> {
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

@ProviderFor(postRepository)
final postRepositoryProvider = PostRepositoryProvider._();

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

final class PostRepositoryProvider
    extends $FunctionalProvider<PostRepository, PostRepository, PostRepository>
    with $Provider<PostRepository> {
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
  PostRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRepositoryHash();

  @$internal
  @override
  $ProviderElement<PostRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostRepository create(Ref ref) {
    return postRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostRepository>(value),
    );
  }
}

String _$postRepositoryHash() => r'1db9b827028cab7fa224ecb922f6284e496c379d';

/// Provides the [GetPostsUseCase] wired with the posts repository.

@ProviderFor(getPostsUseCase)
final getPostsUseCaseProvider = GetPostsUseCaseProvider._();

/// Provides the [GetPostsUseCase] wired with the posts repository.

final class GetPostsUseCaseProvider
    extends
        $FunctionalProvider<GetPostsUseCase, GetPostsUseCase, GetPostsUseCase>
    with $Provider<GetPostsUseCase> {
  /// Provides the [GetPostsUseCase] wired with the posts repository.
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

/// Provides the [GetPostByIdUseCase] wired with the posts repository.
///
/// Mirrors [getPostsUseCaseProvider] above — same repository dependency,
/// same scoping (feature-level, autoDispose). Added so `getPostById` on
/// the repository finally has a matching use case, consistent with the
/// Repository → UseCase → Notifier convention `getPosts` already follows.

@ProviderFor(getPostByIdUseCase)
final getPostByIdUseCaseProvider = GetPostByIdUseCaseProvider._();

/// Provides the [GetPostByIdUseCase] wired with the posts repository.
///
/// Mirrors [getPostsUseCaseProvider] above — same repository dependency,
/// same scoping (feature-level, autoDispose). Added so `getPostById` on
/// the repository finally has a matching use case, consistent with the
/// Repository → UseCase → Notifier convention `getPosts` already follows.

final class GetPostByIdUseCaseProvider
    extends
        $FunctionalProvider<
          GetPostByIdUseCase,
          GetPostByIdUseCase,
          GetPostByIdUseCase
        >
    with $Provider<GetPostByIdUseCase> {
  /// Provides the [GetPostByIdUseCase] wired with the posts repository.
  ///
  /// Mirrors [getPostsUseCaseProvider] above — same repository dependency,
  /// same scoping (feature-level, autoDispose). Added so `getPostById` on
  /// the repository finally has a matching use case, consistent with the
  /// Repository → UseCase → Notifier convention `getPosts` already follows.
  GetPostByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPostByIdUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPostByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPostByIdUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPostByIdUseCase create(Ref ref) {
    return getPostByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPostByIdUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPostByIdUseCase>(value),
    );
  }
}

String _$getPostByIdUseCaseHash() =>
    r'685e683961eb2e4e51d1270004484a66c1158460';
