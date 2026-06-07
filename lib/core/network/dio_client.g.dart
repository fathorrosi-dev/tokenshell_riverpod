// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a fully configured [Dio] instance.
///
/// Configuration:
/// - Base URL from [AppEnv.baseUrl] (set at build time via envied).
/// - Standard timeouts: connect 15 s, receive 30 s, send 15 s.
/// - `Content-Type: application/json` + optional `Authorization` header.
/// - [TalkerDioLogger] interceptor wired to the global [talker] instance.
///
/// [keepAlive: true] — Dio is stateless and safe to keep for the app lifetime.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Provides a fully configured [Dio] instance.
///
/// Configuration:
/// - Base URL from [AppEnv.baseUrl] (set at build time via envied).
/// - Standard timeouts: connect 15 s, receive 30 s, send 15 s.
/// - `Content-Type: application/json` + optional `Authorization` header.
/// - [TalkerDioLogger] interceptor wired to the global [talker] instance.
///
/// [keepAlive: true] — Dio is stateless and safe to keep for the app lifetime.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provides a fully configured [Dio] instance.
  ///
  /// Configuration:
  /// - Base URL from [AppEnv.baseUrl] (set at build time via envied).
  /// - Standard timeouts: connect 15 s, receive 30 s, send 15 s.
  /// - `Content-Type: application/json` + optional `Authorization` header.
  /// - [TalkerDioLogger] interceptor wired to the global [talker] instance.
  ///
  /// [keepAlive: true] — Dio is stateless and safe to keep for the app lifetime.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'2336455914fd7bb6e938e137c8ae0e51177761e3';
