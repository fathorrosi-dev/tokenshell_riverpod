import 'package:sentry_flutter/sentry_flutter.dart';

/// Sets the current authenticated user in Sentry's scope so that every
/// crash and error event after this call carries the user's identifier.
///
/// ## When to call this
///
/// Call once immediately after a successful login — e.g. inside the auth
/// notifier's sign-in action, right after the access token has been
/// persisted to [SecureStorageDatasource]. At that point the user's
/// identity is confirmed and all subsequent errors belong to them.
///
/// Pair every call to [setSentryUser] with a [clearSentryUser] call in
/// the corresponding sign-out action. Failing to clear means a crash that
/// happens after sign-out (but before the app restarts) would still be
/// attributed to the previous session's user — wrong and potentially
/// misleading for support.
///
/// ## Where to wire this
///
/// The DI seam is `accessTokenReaderProvider` in
/// `core/network/interceptors/auth_interceptor.dart`. When a real login
/// feature is added, the provider override that supplies the real token
/// reader is the right place to also set the Sentry user — they both
/// fire at the same moment (user authenticated, token available).
///
/// ## What to pass as userId
///
/// Use a stable, opaque identifier — a database UUID or account number.
/// **Do not pass an email address or display name as `userId`** — Sentry
/// indexes this field for search and it would effectively be stored as
/// PII in your Sentry project. Pass email separately only if your app
/// already shows user emails in support tooling and you've confirmed this
/// is acceptable under your privacy policy.
///
/// ## Example
///
/// ```dart
/// // Inside your auth notifier, after successful login:
/// await secureStorage.write(key: 'access_token', value: token);
/// await setSentryUser(user.id, email: user.email);
/// state = AsyncData(user);
/// ```
Future<void> setSentryUser(String userId, {String? email}) async {
  await Sentry.configureScope(
    (scope) => scope.setUser(
      SentryUser(
        id: userId,
        email: email,
      ),
    ),
  );
}

/// Clears the Sentry user scope on sign-out so subsequent error events
/// are not incorrectly attributed to the just-signed-out user.
///
/// Call this in the sign-out action, before or alongside clearing the
/// access token from [SecureStorageDatasource]. Clearing it before the
/// token is removed ensures there's no window where the token is gone
/// but crashes still carry the old user identity.
///
/// ## Example
///
/// ```dart
/// // Inside your auth notifier, sign-out action:
/// await clearSentryUser();
/// await secureStorage.delete(key: 'access_token');
/// state = const AsyncData(null);
/// ```
Future<void> clearSentryUser() async {
  await Sentry.configureScope(
    (scope) => scope.setUser(null),
  );
}
