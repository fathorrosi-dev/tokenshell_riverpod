// dart run build_runner build --delete-conflicting-outputs
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';

part 'failure_mapper.g.dart';

/// Single boundary where caught exceptions are translated into a [Failure].
///
/// Before this existed, every Repository implementation was expected to
/// hand-roll its own try/catch → Failure mapping — fine for one feature,
/// inconsistent the moment a second developer writes a second repository.
/// Centralizing it here means there is exactly one place that understands
/// what a [DioException] looks like.
///
/// [Talker] is injected rather than called as a global singleton so this
/// class stays unit-testable with a mocked instance, and so swapping the
/// logging backend later doesn't mean hunting down call sites.
class FailureMapper {
  const FailureMapper(this._talker);

  final Talker _talker;

  /// Maps any caught [error] to a [Failure], logging the original error and
  /// [stackTrace] exactly once at this boundary — this is the only place in
  /// the codebase that should ever see a raw [DioException] or platform
  /// exception. Everything above this call only ever deals with [Failure].
  Failure call(Object error, [StackTrace? stackTrace]) {
    final failure = switch (error) {
      DioException() => _fromDioException(error),
      // R-17 (2 Jul 2026): flutter_secure_storage surfaces platform-channel
      // failures (e.g. a corrupted Android Keystore after an OS restore —
      // a real, documented failure mode, not a hypothetical) as a raw
      // [PlatformException]. Previously this fell into the generic
      // catch-all below and surfaced as `UnknownFailure`, indistinguishable
      // from any other unclassified error. Mapping it to [Failure.cache]
      // matches the label already reserved for local-storage failures and
      // lets the UI/Notifier layer react the same way it would to a
      // SharedPreferences failure. `SecureStorageDatasource` itself stays
      // throw-based on purpose — see its class doc comment — this is the
      // one place that catches it, same as every `DioException`.
      PlatformException() => const Failure.cache(
        message: 'Failed to read or write secure storage.',
      ),
      // Already mapped by a lower layer (e.g. a datasource) — pass through
      // instead of double-wrapping it into an UnknownFailure.
      Failure() => error,
      _ => const Failure.unknown(),
    };

    // Logged here, not stored on Failure — see the design note in
    // failure.dart for why stack traces never travel past this point.
    _talker.handle(error, stackTrace, 'Mapped to ${failure.label}');

    return failure;
  }

  Failure _fromDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const Failure.timeout(),
      DioExceptionType.connectionError => const Failure.network(),
      DioExceptionType.badResponse => _fromStatusCode(error),
      DioExceptionType.cancel => const Failure.unknown(
        message: 'Request was cancelled.',
      ),
      // R-15 (2 Jul 2026): split out from the generic catch-all below so a
      // TLS/certificate problem gets its own message instead of the fully
      // generic one. Still maps to `UnknownFailure` — no dedicated Failure
      // subtype, since certificate pinning itself is out of scope at this
      // audit's Balanced depth — but the raw `DioException` logged by
      // `call()` above already carries `type: badCertificate`, and this
      // message makes the same signal visible to the user, not just in
      // the log.
      DioExceptionType.badCertificate => const Failure.unknown(
        message:
            'Could not establish a secure connection. Please try '
            'again later or contact support if the problem continues.',
      ),
      // unknown, etc. — no specific recovery path exists, so it falls
      // back to the generic catch-all rather than guessing.
      _ => const Failure.unknown(),
    };
  }

  Failure _fromStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    return switch (statusCode) {
      401 || 403 => Failure.auth(statusCode: statusCode),
      422 => Failure.validation(
        message: _extractMessage(error) ?? 'Validation failed.',
        fieldErrors: _extractFieldErrors(error),
      ),
      // R-17 (2 Jul 2026): previously fell through to the generic 5xx-style
      // message below, indistinguishable from "the server is actually
      // down." A 429 means the opposite — the server is healthy and asking
      // us to slow down. No dedicated Failure subtype is introduced here
      // (that would require regenerating the Freezed union), so this still
      // maps to ServerFailure, but with a message that tells the user (and
      // anything reading Sentry/Talker) what's actually going on, including
      // the server's own wait-time hint when it provides one. See
      // `RetryInterceptor`'s R17 doc comment — this is the same 429 case,
      // reached only when retries there are exhausted or the response
      // wasn't a GET/explicitly-retryable request in the first place.
      429 => Failure.server(
        message: _extractMessage(error) ?? _rateLimitedMessage(error),
        statusCode: statusCode,
      ),
      _ => Failure.server(
        message: _extractMessage(error) ?? 'Server error occurred.',
        statusCode: statusCode,
      ),
    };
  }

  /// Default message for a 429 with no backend-supplied `message` field.
  /// Includes the `Retry-After` wait time when the header is present and
  /// parses as plain delta-seconds, so the user sees "try again in 30s"
  /// instead of a generic "try again later."
  String _rateLimitedMessage(DioException error) {
    final retryAfter = error.response?.headers.value('retry-after');
    final seconds = retryAfter == null ? null : int.tryParse(retryAfter.trim());
    if (seconds != null && seconds > 0) {
      return 'Too many requests. Please try again in ${seconds}s.';
    }
    return 'Too many requests. Please try again shortly.';
  }

  /// Reads a human-readable message from a `{ "message": "..." }`-shaped
  /// response body, if the backend follows that convention. Returns null
  /// instead of throwing if the shape doesn't match — caller falls back to
  /// a sane default rather than crashing on a malformed error response.
  ///
  /// R-14 (2 Jul 2026): the raw string is passed through [_sanitizeMessage]
  /// before reaching the UI. The backend behind this is first-party today,
  /// but nothing stops a future repository from routing a third-party or
  /// legacy API through this same [FailureMapper] — this boundary
  /// shouldn't assume every caller will be equally trustworthy forever.
  String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] is String) {
      return _sanitizeMessage(data['message'] as String);
    }
    return null;
  }

  /// Caps length and strips control characters from a backend-sourced
  /// error string before it's shown to the user.
  ///
  /// Not an XSS concern — Flutter's [Text] widget never interprets HTML —
  /// but an unbounded or control-character-laden string from a
  /// misbehaving backend can still break layout (a one-line SnackBar
  /// suddenly rendering a multi-KB response body) or forward something
  /// the backend never intended to be user-facing, such as a stray
  /// internal path or stack-trace fragment appended to a `message` field
  /// by mistake.
  ///
  /// Returns null — same contract as [_extractMessage] — if nothing
  /// usable survives sanitization, so the caller's default message takes
  /// over instead of showing an empty banner.
  String? _sanitizeMessage(String raw) {
    // Strip control/formatting characters (newlines, tabs, and other
    // non-printable bytes) that have no place in a single-line UI message.
    final cleaned = raw.replaceAll(RegExp(r'[\x00-\x1F\x7F]+'), ' ').trim();
    if (cleaned.isEmpty) return null;

    const maxLength = 300;
    if (cleaned.length <= maxLength) return cleaned;
    return '${cleaned.substring(0, maxLength)}…';
  }

  /// Reads field-level validation errors from a
  /// `{ "errors": { "email": ["..."] } }`-shaped response body, if present.
  /// Adjust this to match your backend's actual error envelope.
  Map<String, List<String>>? _extractFieldErrors(DioException error) {
    final data = error.response?.data;
    if (data is! Map<String, dynamic>) return null;
    final errors = data['errors'];
    if (errors is! Map<String, dynamic>) return null;
    return errors.map(
      (key, value) => MapEntry(
        key,
        value is List ? value.map((e) => e.toString()).toList() : <String>[],
      ),
    );
  }
}

/// Feature-level scope is wrong here on purpose — every Repository across
/// every feature needs the same mapping behavior, so this is one of the
/// few providers that's intentionally app-wide rather than scoped.
///
/// Previously a hand-written `Provider<FailureMapper>(...)` — converted to
/// codegen so every app-wide provider in Core follows the same declaration
/// pattern as `connectivityProvider` / `dioProvider`, instead of mixing
/// manual and generated providers for the same kind of job. See
/// `core/logging/talker_provider.dart` for the one deliberate, documented
/// exception to this convention.
@Riverpod(keepAlive: true)
FailureMapper failureMapper(Ref ref) {
  return FailureMapper(ref.watch(talkerProvider));
}
