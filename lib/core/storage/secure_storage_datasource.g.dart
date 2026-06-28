// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app's [ISecureStorageDatasource] instance.
///
/// Returns the interface type — consumers never need to know they're talking
/// to [SecureStorageDatasource] specifically. This keeps the provider
/// overridable in tests:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     secureStorageDatasourceProvider.overrideWithValue(
///       FakeSecureStorageDatasource(),
///     ),
///   ],
/// )
/// ```
///
/// [keepAlive: true] — storage is an app-lifetime infrastructure dependency.
/// Disposing and recreating it between screen transitions would be wasteful.

@ProviderFor(secureStorageDatasource)
final secureStorageDatasourceProvider = SecureStorageDatasourceProvider._();

/// Provides the app's [ISecureStorageDatasource] instance.
///
/// Returns the interface type — consumers never need to know they're talking
/// to [SecureStorageDatasource] specifically. This keeps the provider
/// overridable in tests:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     secureStorageDatasourceProvider.overrideWithValue(
///       FakeSecureStorageDatasource(),
///     ),
///   ],
/// )
/// ```
///
/// [keepAlive: true] — storage is an app-lifetime infrastructure dependency.
/// Disposing and recreating it between screen transitions would be wasteful.

final class SecureStorageDatasourceProvider
    extends
        $FunctionalProvider<
          ISecureStorageDatasource,
          ISecureStorageDatasource,
          ISecureStorageDatasource
        >
    with $Provider<ISecureStorageDatasource> {
  /// Provides the app's [ISecureStorageDatasource] instance.
  ///
  /// Returns the interface type — consumers never need to know they're talking
  /// to [SecureStorageDatasource] specifically. This keeps the provider
  /// overridable in tests:
  ///
  /// ```dart
  /// ProviderScope(
  ///   overrides: [
  ///     secureStorageDatasourceProvider.overrideWithValue(
  ///       FakeSecureStorageDatasource(),
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  /// [keepAlive: true] — storage is an app-lifetime infrastructure dependency.
  /// Disposing and recreating it between screen transitions would be wasteful.
  SecureStorageDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageDatasourceHash();

  @$internal
  @override
  $ProviderElement<ISecureStorageDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ISecureStorageDatasource create(Ref ref) {
    return secureStorageDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISecureStorageDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISecureStorageDatasource>(value),
    );
  }
}

String _$secureStorageDatasourceHash() =>
    r'da68664017e565967e76ad267310de9003866d43';
