// dart run build_runner build --delete-conflicting-outputs
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor.g.dart';

/// A callable that returns the current user's access token, or null if
/// there's no authenticated session (including "no login feature exists
/// yet").
///
/// A plain function type rather than a class — same reasoning as
/// `ConnectivityGuard` in `connectivity_provider.dart`: this is a single
/// capability with no state of its own, fully swappable via DI. A future
/// implementation that needs dependencies (e.g. reading from
/// `FlutterSecureStorage`) captures them in a closure; it doesn't need a
/// class to hold them. (An IDE inspection flagged the original
/// single-method `abstract interface class` version of this as
/// unnecessary — it was right: nothing here actually needed class
/// semantics.)
typedef AccessTokenReader = Future<String?> Function();

/// Default reader used until a real login feature is built. Always
/// returns null, so [AuthInterceptor] does nothing — requests keep relying
/// solely on the static `AppEnv.apiKey` header set in `dio_client.dart`'s
/// `BaseOptions`, exactly as before this existed. Once a login feature
/// exists, override [accessTokenReaderProvider] with a closure that reads
/// the real token — [AuthInterceptor] itself never needs to change.
Future<String?> _noAccessToken() async => null;

/// Attaches the current user's access token to every outgoing request, if
/// one exists.
///
/// Deliberately does NOT attempt token refresh or retry-after-401 — there
/// is no refresh-token endpoint contract to build against yet (no login
/// feature exists at the time this was written, per the architecture
/// review). A 401 still flows through normally and gets mapped to
/// `AuthFailure` by `FailureMapper`. Wire a refresh flow in here once the
/// actual login/refresh contract is known — building it speculatively now
/// would just be guessing at an API that doesn't exist.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._readToken);

  final AccessTokenReader _readToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

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
@Riverpod(keepAlive: true)
AccessTokenReader accessTokenReader(Ref ref) => _noAccessToken;
