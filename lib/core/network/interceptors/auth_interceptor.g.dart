// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI seam for [AccessTokenReader]. Override this single provider once a
/// real login feature exists — [AuthInterceptor] and `dio_client.dart`
/// don't need to know anything changed.
///
/// Previously a hand-written `Provider<AccessTokenReader>(..., name: ...)`
/// — converted to codegen so this app-wide provider follows the same
/// declaration pattern as the rest of Core instead of needing a
/// manually-typed debug `name:` string. See
/// `core/logging/talker_provider.dart` for the one deliberate exception
/// that's staying manual, and why.
///
/// ## Sentry user scope (R-03 — 27 Jun 2026)
///
/// When you override this provider with a real token reader, also wire
/// [setSentryUser] / [clearSentryUser] from
/// `core/observability/sentry_user_scope.dart` in the same auth action:
///
/// ```dart
/// // Login success:
/// await secureStorage.write(key: 'access_token', value: token);
/// await setSentryUser(user.id, email: user.email);
///
/// // Sign-out:
/// await clearSentryUser();
/// await secureStorage.delete(key: 'access_token');
/// ```
///
/// Without this, crashes in production cannot be attributed to a specific
/// client account — making support triage significantly harder for a B2B
/// SaaS like Baseline.

@ProviderFor(accessTokenReader)
final accessTokenReaderProvider = AccessTokenReaderProvider._();

/// DI seam for [AccessTokenReader]. Override this single provider once a
/// real login feature exists — [AuthInterceptor] and `dio_client.dart`
/// don't need to know anything changed.
///
/// Previously a hand-written `Provider<AccessTokenReader>(..., name: ...)`
/// — converted to codegen so this app-wide provider follows the same
/// declaration pattern as the rest of Core instead of needing a
/// manually-typed debug `name:` string. See
/// `core/logging/talker_provider.dart` for the one deliberate exception
/// that's staying manual, and why.
///
/// ## Sentry user scope (R-03 — 27 Jun 2026)
///
/// When you override this provider with a real token reader, also wire
/// [setSentryUser] / [clearSentryUser] from
/// `core/observability/sentry_user_scope.dart` in the same auth action:
///
/// ```dart
/// // Login success:
/// await secureStorage.write(key: 'access_token', value: token);
/// await setSentryUser(user.id, email: user.email);
///
/// // Sign-out:
/// await clearSentryUser();
/// await secureStorage.delete(key: 'access_token');
/// ```
///
/// Without this, crashes in production cannot be attributed to a specific
/// client account — making support triage significantly harder for a B2B
/// SaaS like Baseline.

final class AccessTokenReaderProvider
    extends
        $FunctionalProvider<
          AccessTokenReader,
          AccessTokenReader,
          AccessTokenReader
        >
    with $Provider<AccessTokenReader> {
  /// DI seam for [AccessTokenReader]. Override this single provider once a
  /// real login feature exists — [AuthInterceptor] and `dio_client.dart`
  /// don't need to know anything changed.
  ///
  /// Previously a hand-written `Provider<AccessTokenReader>(..., name: ...)`
  /// — converted to codegen so this app-wide provider follows the same
  /// declaration pattern as the rest of Core instead of needing a
  /// manually-typed debug `name:` string. See
  /// `core/logging/talker_provider.dart` for the one deliberate exception
  /// that's staying manual, and why.
  ///
  /// ## Sentry user scope (R-03 — 27 Jun 2026)
  ///
  /// When you override this provider with a real token reader, also wire
  /// [setSentryUser] / [clearSentryUser] from
  /// `core/observability/sentry_user_scope.dart` in the same auth action:
  ///
  /// ```dart
  /// // Login success:
  /// await secureStorage.write(key: 'access_token', value: token);
  /// await setSentryUser(user.id, email: user.email);
  ///
  /// // Sign-out:
  /// await clearSentryUser();
  /// await secureStorage.delete(key: 'access_token');
  /// ```
  ///
  /// Without this, crashes in production cannot be attributed to a specific
  /// client account — making support triage significantly harder for a B2B
  /// SaaS like Baseline.
  AccessTokenReaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTokenReaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTokenReaderHash();

  @$internal
  @override
  $ProviderElement<AccessTokenReader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccessTokenReader create(Ref ref) {
    return accessTokenReader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessTokenReader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessTokenReader>(value),
    );
  }
}

String _$accessTokenReaderHash() => r'b17b7b6eaa13298728a270149969d695d93b3b75';
