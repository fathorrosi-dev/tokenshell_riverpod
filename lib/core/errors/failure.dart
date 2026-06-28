import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Sealed failure hierarchy used across all repository and use-case layers.
///
/// Never throw raw exceptions above the data layer — always map them to a
/// [Failure] subtype via `FailureMapper` and return it through
// ignore: comment_references
/// [fpdart]'s `Either.left`.
///
/// Design note — no [StackTrace] or original exception is stored here.
/// Freezed generates `==`/`hashCode` from every constructor field, and a
/// [StackTrace] is identity-compared (two captures of "the same" error are
/// never `==`). Embedding it would make any Failure produced at runtime
/// permanently unequal to the same Failure constructed in a test — e.g.
/// `expect(result, Left(NetworkFailure()))` would never pass. The original
/// exception + stack trace are logged exactly once, at the point they're
/// caught, by `FailureMapper` (see failure_mapper.dart) — never carried any
/// deeper into the domain than that.
@freezed
sealed class Failure with _$Failure implements Exception {
  const Failure._();

  /// No network connection (no IP route, DNS failure, airplane mode, etc).
  /// Kept separate from [TimeoutFailure] because the recommended user
  /// action differs — check your connection vs. just try again.
  const factory Failure.network({
    @Default('No internet connection. Please check your network and try again.')
    String message,
  }) = NetworkFailure;

  /// Request exceeded its time budget while a connection was otherwise
  /// present. Typically recoverable with an automatic or user-triggered
  /// retry, unlike [NetworkFailure].
  const factory Failure.timeout({
    @Default('Request timed out. Please try again.') String message,
  }) = TimeoutFailure;

  /// Server-side failure that isn't an auth or validation problem — other
  /// 4xx/5xx status codes, or a response that could not be parsed into the
  /// expected model.
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  /// Expired session or insufficient permission (401 / 403). Kept separate
  /// from [ServerFailure] because the UI response is fundamentally
  /// different — force logout / token refresh, not a generic error banner.
  const factory Failure.auth({
    @Default('Session expired or unauthorized. Please log in again.')
    String message,
    int? statusCode,
  }) = AuthFailure;

  /// Business-rule or form-validation failure (typically HTTP 422), carrying
  /// per-field messages so the Presentation layer can highlight the exact
  /// invalid field instead of showing one generic banner.
  const factory Failure.validation({
    required String message,
    Map<String, List<String>>? fieldErrors,
  }) = ValidationFailure;

  /// Failure reading or writing local storage (SharedPreferences, secure
  /// storage, or an on-device database).
  const factory Failure.cache({
    @Default('Failed to read or write local cache.') String message,
  }) = CacheFailure;

  /// Catch-all for exceptions that do not fit the above categories.
  const factory Failure.unknown({
    @Default('An unexpected error occurred.') String message,
  }) = UnknownFailure;

  /// Short type label for logging/analytics. Kept separate from the
  /// Freezed-generated [toString] (which prints full field values) so call
  /// sites that just want the category name don't need to parse a string.
  String get label => switch (this) {
    NetworkFailure() => 'NetworkFailure',
    TimeoutFailure() => 'TimeoutFailure',
    ServerFailure() => 'ServerFailure',
    AuthFailure() => 'AuthFailure',
    ValidationFailure() => 'ValidationFailure',
    CacheFailure() => 'CacheFailure',
    UnknownFailure() => 'UnknownFailure',
  };
}
