// dart run build_runner build --delete-conflicting-outputs
import 'package:dio/dio.dart';
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
      // badCertificate, unknown, etc. — no specific recovery path exists,
      // so they fall back to the generic catch-all rather than guessing.
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
      _ => Failure.server(
        message: _extractMessage(error) ?? 'Server error occurred.',
        statusCode: statusCode,
      ),
    };
  }

  /// Reads a human-readable message from a `{ "message": "..." }`-shaped
  /// response body, if the backend follows that convention. Returns null
  /// instead of throwing if the shape doesn't match — caller falls back to
  /// a sane default rather than crashing on a malformed error response.
  String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
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
