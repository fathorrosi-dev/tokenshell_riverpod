// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a fully-constructed [IThemeModeRepository]
/// backed by [SharedPreferences].
///
/// Exposing the return type as the interface rather than the concrete
/// implementation allows tests to override this provider with any
/// [IThemeModeRepository] implementation without changing consumers.

@ProviderFor(themeModeRepository)
final themeModeRepositoryProvider = ThemeModeRepositoryProvider._();

/// Provides a fully-constructed [IThemeModeRepository]
/// backed by [SharedPreferences].
///
/// Exposing the return type as the interface rather than the concrete
/// implementation allows tests to override this provider with any
/// [IThemeModeRepository] implementation without changing consumers.

final class ThemeModeRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<IThemeModeRepository>,
          IThemeModeRepository,
          FutureOr<IThemeModeRepository>
        >
    with
        $FutureModifier<IThemeModeRepository>,
        $FutureProvider<IThemeModeRepository> {
  /// Provides a fully-constructed [IThemeModeRepository]
  /// backed by [SharedPreferences].
  ///
  /// Exposing the return type as the interface rather than the concrete
  /// implementation allows tests to override this provider with any
  /// [IThemeModeRepository] implementation without changing consumers.
  ThemeModeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<IThemeModeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IThemeModeRepository> create(Ref ref) {
    return themeModeRepository(ref);
  }
}

String _$themeModeRepositoryHash() =>
    r'4f6a80cf4586116366177779c8053ea7add3f3a7';
