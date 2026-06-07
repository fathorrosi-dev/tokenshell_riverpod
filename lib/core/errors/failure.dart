import 'package:fpdart/fpdart.dart';

/// Sealed failure hierarchy used across all repository and use-case layers.
///
/// Never throw raw exceptions above the data layer — always map them to a
// ignore: comment_references
/// [Failure] subtype and return it via [fpdart]'s [Either.left].
sealed class Failure implements Exception {
  const Failure({required this.message, this.stackTrace});

  /// Human-readable description of what went wrong.
  final String message;

  /// Optional stack trace for debugging — never surfaced in production UI.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final type = switch (this) {
      NetworkFailure() => 'NetworkFailure',
      ServerFailure() => 'ServerFailure',
      CacheFailure() => 'CacheFailure',
      UnknownFailure() => 'UnknownFailure',
    };
    return '$type: $message';
  }
}

/// Failure caused by the absence of a network connection or a connection
/// timeout before the server responded.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection or request timed out.',
    super.stackTrace,
  });
}

/// Failure returned by the server — 4xx / 5xx HTTP status codes, or a
/// response that could not be parsed into the expected model.
final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
    super.stackTrace,
  });

  /// HTTP status code from the response, if available.
  final int? statusCode;
}

/// Failure arising from reading or writing local storage (SharedPreferences,
/// secure storage, or an on-device database).
final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to read or write local cache.',
    super.stackTrace,
  });
}

/// Catch-all failure for exceptions that do not fit the above categories.
final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.stackTrace,
  });
}
