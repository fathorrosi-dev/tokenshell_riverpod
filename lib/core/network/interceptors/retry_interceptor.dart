import 'dart:math' as math;

import 'package:dio/dio.dart';

/// Automatically retries a request that failed for a reason that's usually
/// transient on a mobile network — connection/timeout errors, a 5xx
/// response, or a 429 (rate limited) response. Never retries any other 4xx
/// (the request itself was wrong; retrying changes nothing) and never
/// retries a non-GET request by default, since blindly re-sending a
/// POST/PATCH/DELETE that already reached the server risks duplicate side
/// effects (double-charging, duplicate records, etc).
///
/// ## 429 handling (R17)
///
/// A 429 is treated differently from a 5xx: it means the server is healthy
/// but asking us to slow down, and it may tell us exactly how long to wait
/// via a `Retry-After` header (either delta-seconds, e.g. `"120"`, or an
/// HTTP-date per RFC 7231 §7.1.3). When present and parseable, that value
/// is used verbatim instead of the exponential-backoff schedule — honoring
/// the server's stated wait time is both more correct and less likely to
/// trigger a second 429. If the header is missing or unparseable, 429s fall
/// back to the same jittered exponential backoff as everything else.
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

    final delay = _retryAfterDelay(err) ?? _delayWithJitter(attempt);
    await Future<void>.delayed(delay);

    final retryOptions = err.requestOptions.copyWith(
      extra: {...err.requestOptions.extra, 'retryAttempt': attempt + 1},
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
      DioExceptionType.badResponse => _isRetryableStatus(
        err.response?.statusCode,
      ),
      _ => false,
    };
  }

  bool _isRetryableStatus(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode >= 500 || statusCode == 429;
  }

  /// Longest `Retry-After` delay we'll actually honor. A well-behaved
  /// backend shouldn't send anything close to this, but capping it stops a
  /// misconfigured or malicious response from stalling the request pipeline
  /// for an unbounded amount of time.
  static const Duration _maxRetryAfterDelay = Duration(seconds: 60);

  /// Parses the `Retry-After` header (RFC 7231 §7.1.3) off a 429 response,
  /// per the format used by delta-seconds (`"120"`) or an HTTP-date
  /// (`"Wed, 21 Oct 2026 07:28:00 GMT"`). Returns `null` for any other
  /// status code, a missing header, or a value that fails to parse — the
  /// caller falls back to jittered exponential backoff in that case.
  Duration? _retryAfterDelay(DioException err) {
    if (err.response?.statusCode != 429) return null;

    final raw = err.response?.headers.value('retry-after');
    if (raw == null || raw.isEmpty) return null;

    final seconds = int.tryParse(raw.trim());
    if (seconds != null) {
      final delay = Duration(seconds: math.max(0, seconds));
      return delay > _maxRetryAfterDelay ? _maxRetryAfterDelay : delay;
    }

    final date = _parseHttpDate(raw.trim());
    if (date != null) {
      final delay = date.difference(DateTime.now().toUtc());
      if (delay.isNegative) return Duration.zero;
      return delay > _maxRetryAfterDelay ? _maxRetryAfterDelay : delay;
    }

    return null;
  }

  static const Map<String, int> _httpDateMonths = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  // Matches the IMF-fixdate form RFC 7231 §7.1.1.1 mandates for generation,
  // e.g. "Wed, 21 Oct 2026 07:28:00 GMT". `DateTime.tryParse` cannot parse
  // this (it only understands ISO 8601), so it's handled explicitly here
  // rather than silently failing and always falling back to backoff.
  static final RegExp _httpDatePattern = RegExp(
    r'^\w{3}, (\d{2}) (\w{3}) (\d{4}) (\d{2}):(\d{2}):(\d{2}) GMT$',
  );

  /// Parses an RFC 7231 IMF-fixdate string into a UTC [DateTime]. Returns
  /// `null` if [value] doesn't match the expected format or names an
  /// unrecognized month — the caller falls back to jittered backoff.
  DateTime? _parseHttpDate(String value) {
    final match = _httpDatePattern.firstMatch(value);
    if (match == null) return null;

    final month = _httpDateMonths[match.group(2)];
    if (month == null) return null;

    return DateTime.utc(
      int.parse(match.group(3)!),
      month,
      int.parse(match.group(1)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
  }
}
