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
/// - `Content-Type: application/json` + optional static `X-Api-Key`
///   header from [AppEnv.apiKey].
/// - [AuthInterceptor] — attaches a per-user access token via the
///   `Authorization` header, if one exists. Today this is always a no-op
///   (default `accessTokenReaderProvider` value) since there's no login
///   feature yet; wiring a real one only means overriding
///   `accessTokenReaderProvider` — nothing here needs to change.
///
///   `X-Api-Key` and `Authorization` are deliberately two different
///   headers, not one. They mean two different things: `X-Api-Key`
///   identifies *this app build* to the backend (a project-level secret,
///   present on every request regardless of who's using the app);
///   `Authorization` identifies *the signed-in user*. Earlier both wrote
///   to `Authorization`, so the per-user token would have silently
///   overwritten the static key the moment a real login feature set a
///   non-null token — an implicit, undocumented collision rather than a
///   deliberate choice. Keeping them on separate headers means a future
///   login feature can land without anyone needing to remember this.
/// - [RetryInterceptor] — auto-retries transient failures (timeouts, 5xx)
///   on GET requests.
/// - [TalkerDioLogger] — logs every attempt, including retries, since each
///   retry is a fresh pass through this same interceptor chain. Settings
///   come from [LogLevelPolicy.dioLoggerSettings] (added 25 Jun 2026) —
///   permanently redacts `Authorization`/`X-Api-Key` headers and stops
///   printing request/response bodies in `AppFlavor.prod`; see that
///   class's doc comment for why this is a permanent setting, not a
///   stopgap until a real login feature exists.
/// - `dio.addSentry()` — adds Sentry HTTP breadcrumbs + performance
///   tracing. Called LAST, after every interceptor above is already
///   attached: this is Sentry's own documented requirement for
///   `sentry_dio`, since calling it earlier risks a later interceptor
///   addition overwriting Sentry's own instrumentation. (This is *not*
///   the same kind of "order" concern as Auth-before-Retry-before-Logger
///   above — those three care about which interceptor's `onRequest` sees
///   the request first; `addSentry()` is an extension method that needs
///   to be the final setup call, not an interceptor slotted into a
///   specific position in the list.)
///
/// Interceptor order is deliberate: Auth runs first so even a retried
/// request carries a fresh token; Retry runs before Logger so every
/// attempt (original + retries) gets logged individually instead of only
/// the final outcome.
///
/// `keepAlive: true` — Dio is stateless and safe to keep for the app lifetime.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Provides a fully configured [Dio] instance.
///
/// Configuration:
/// - Base URL from [AppEnv.baseUrl] (set at build time via envied).
/// - Standard timeouts: connect 15 s, receive 30 s, send 15 s.
/// - `Content-Type: application/json` + optional static `X-Api-Key`
///   header from [AppEnv.apiKey].
/// - [AuthInterceptor] — attaches a per-user access token via the
///   `Authorization` header, if one exists. Today this is always a no-op
///   (default `accessTokenReaderProvider` value) since there's no login
///   feature yet; wiring a real one only means overriding
///   `accessTokenReaderProvider` — nothing here needs to change.
///
///   `X-Api-Key` and `Authorization` are deliberately two different
///   headers, not one. They mean two different things: `X-Api-Key`
///   identifies *this app build* to the backend (a project-level secret,
///   present on every request regardless of who's using the app);
///   `Authorization` identifies *the signed-in user*. Earlier both wrote
///   to `Authorization`, so the per-user token would have silently
///   overwritten the static key the moment a real login feature set a
///   non-null token — an implicit, undocumented collision rather than a
///   deliberate choice. Keeping them on separate headers means a future
///   login feature can land without anyone needing to remember this.
/// - [RetryInterceptor] — auto-retries transient failures (timeouts, 5xx)
///   on GET requests.
/// - [TalkerDioLogger] — logs every attempt, including retries, since each
///   retry is a fresh pass through this same interceptor chain. Settings
///   come from [LogLevelPolicy.dioLoggerSettings] (added 25 Jun 2026) —
///   permanently redacts `Authorization`/`X-Api-Key` headers and stops
///   printing request/response bodies in `AppFlavor.prod`; see that
///   class's doc comment for why this is a permanent setting, not a
///   stopgap until a real login feature exists.
/// - `dio.addSentry()` — adds Sentry HTTP breadcrumbs + performance
///   tracing. Called LAST, after every interceptor above is already
///   attached: this is Sentry's own documented requirement for
///   `sentry_dio`, since calling it earlier risks a later interceptor
///   addition overwriting Sentry's own instrumentation. (This is *not*
///   the same kind of "order" concern as Auth-before-Retry-before-Logger
///   above — those three care about which interceptor's `onRequest` sees
///   the request first; `addSentry()` is an extension method that needs
///   to be the final setup call, not an interceptor slotted into a
///   specific position in the list.)
///
/// Interceptor order is deliberate: Auth runs first so even a retried
/// request carries a fresh token; Retry runs before Logger so every
/// attempt (original + retries) gets logged individually instead of only
/// the final outcome.
///
/// `keepAlive: true` — Dio is stateless and safe to keep for the app lifetime.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provides a fully configured [Dio] instance.
  ///
  /// Configuration:
  /// - Base URL from [AppEnv.baseUrl] (set at build time via envied).
  /// - Standard timeouts: connect 15 s, receive 30 s, send 15 s.
  /// - `Content-Type: application/json` + optional static `X-Api-Key`
  ///   header from [AppEnv.apiKey].
  /// - [AuthInterceptor] — attaches a per-user access token via the
  ///   `Authorization` header, if one exists. Today this is always a no-op
  ///   (default `accessTokenReaderProvider` value) since there's no login
  ///   feature yet; wiring a real one only means overriding
  ///   `accessTokenReaderProvider` — nothing here needs to change.
  ///
  ///   `X-Api-Key` and `Authorization` are deliberately two different
  ///   headers, not one. They mean two different things: `X-Api-Key`
  ///   identifies *this app build* to the backend (a project-level secret,
  ///   present on every request regardless of who's using the app);
  ///   `Authorization` identifies *the signed-in user*. Earlier both wrote
  ///   to `Authorization`, so the per-user token would have silently
  ///   overwritten the static key the moment a real login feature set a
  ///   non-null token — an implicit, undocumented collision rather than a
  ///   deliberate choice. Keeping them on separate headers means a future
  ///   login feature can land without anyone needing to remember this.
  /// - [RetryInterceptor] — auto-retries transient failures (timeouts, 5xx)
  ///   on GET requests.
  /// - [TalkerDioLogger] — logs every attempt, including retries, since each
  ///   retry is a fresh pass through this same interceptor chain. Settings
  ///   come from [LogLevelPolicy.dioLoggerSettings] (added 25 Jun 2026) —
  ///   permanently redacts `Authorization`/`X-Api-Key` headers and stops
  ///   printing request/response bodies in `AppFlavor.prod`; see that
  ///   class's doc comment for why this is a permanent setting, not a
  ///   stopgap until a real login feature exists.
  /// - `dio.addSentry()` — adds Sentry HTTP breadcrumbs + performance
  ///   tracing. Called LAST, after every interceptor above is already
  ///   attached: this is Sentry's own documented requirement for
  ///   `sentry_dio`, since calling it earlier risks a later interceptor
  ///   addition overwriting Sentry's own instrumentation. (This is *not*
  ///   the same kind of "order" concern as Auth-before-Retry-before-Logger
  ///   above — those three care about which interceptor's `onRequest` sees
  ///   the request first; `addSentry()` is an extension method that needs
  ///   to be the final setup call, not an interceptor slotted into a
  ///   specific position in the list.)
  ///
  /// Interceptor order is deliberate: Auth runs first so even a retried
  /// request carries a fresh token; Retry runs before Logger so every
  /// attempt (original + retries) gets logged individually instead of only
  /// the final outcome.
  ///
  /// `keepAlive: true` — Dio is stateless and safe to keep for the app lifetime.
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

String _$dioHash() => r'83f1057307b262d3ab978c383cd7239aa9484303';
