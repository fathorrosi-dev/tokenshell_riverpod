import 'dart:math' as math;

import 'package:dio/dio.dart';

/// Automatically retries a request that failed for a reason that's usually
/// transient on a mobile network — connection/timeout errors, or a 5xx
/// response. Never retries a 4xx (the request itself was wrong; retrying
/// changes nothing) and never retries a non-GET request by default, since
/// blindly re-sending a POST/PATCH/DELETE that already reached the server
/// risks duplicate side effects (double-charging, duplicate records, etc).
///
/// A caller that knows a specific non-GET endpoint is genuinely idempotent
/// on the backend can opt in per-request:
/// `dio.put(path, options: Options(extra: {'retryable': true}))`.
///
/// Retry state travels in `RequestOptions.extra['retryAttempt']` rather
/// than an instance field, because this same [Interceptor] instance
/// handles every in-flight request concurrently — an instance field would
/// mix up the attempt count between unrelated requests.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxAttempts = 2,
    this.baseDelay = const Duration(milliseconds: 500),
    math.Random? random,
  }) : _random = random ?? math.Random();

  final Dio _dio;

  /// Retry attempts after the initial failed request — total requests sent
  /// for a request that keeps failing is `maxAttempts + 1`.
  final int maxAttempts;

  /// Delay before the first retry; doubles each subsequent attempt (simple
  /// exponential backoff) so a struggling connection or server gets a
  /// moment to recover instead of being retried into immediately.
  final Duration baseDelay;

  /// Source of randomness for [_delayWithJitter]. Injectable so a caller
  /// (or a future test) can pass a seeded [math.Random] for deterministic
  /// timing instead of relying on the default unseeded one.
  final math.Random _random;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra['retryAttempt'] as int?) ?? 0;

    if (!_shouldRetry(err) || attempt >= maxAttempts) {
      handler.next(err);
      return;
    }

    await Future<void>.delayed(_delayWithJitter(attempt));

    final retryOptions = err.requestOptions.copyWith(
      extra: {
        ...err.requestOptions.extra,
        'retryAttempt': attempt + 1,
      },
    );

    try {
      final response = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      // If this retry also failed, this same interceptor's onError fires
      // again for `retryError` — with `retryAttempt` already incremented —
      // so the attempt count keeps advancing correctly instead of looping.
      handler.next(retryError);
    }
  }

  /// Exponential backoff (`baseDelay * 2^attempt`) with ±20% random jitter.
  ///
  /// Pure exponential backoff alone is fully deterministic — if many
  /// clients hit the same failing endpoint around the same time (e.g. a
  /// bad deploy that 503s for a few seconds), they all retry in lockstep,
  /// producing a small thundering-herd right as the server is trying to
  /// recover. Jitter spreads those retries out instead. ±20% is enough to
  /// de-synchronize clients without making retry timing in the Talker logs
  /// wildly unpredictable when reading them back later.
  Duration _delayWithJitter(int attempt) {
    final base = baseDelay * (1 << attempt);
    final jitterFraction = (_random.nextDouble() * 2 - 1) * 0.2; // -0.2..0.2
    final jitteredMs = (base.inMilliseconds * (1 + jitterFraction)).round();
    return Duration(milliseconds: math.max(0, jitteredMs));
  }

  bool _shouldRetry(DioException err) {
    final isGet = err.requestOptions.method.toUpperCase() == 'GET';
    final isExplicitlyRetryable = err.requestOptions.extra['retryable'] == true;
    if (!isGet && !isExplicitlyRetryable) return false;

    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse => (err.response?.statusCode ?? 0) >= 500,
      _ => false,
    };
  }
}
