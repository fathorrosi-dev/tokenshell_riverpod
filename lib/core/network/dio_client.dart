// dart run build_runner build --delete-conflicting-outputs
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:tokenshell_riverpod/core/env/app_env.dart';
import 'package:tokenshell_riverpod/main.dart';

part 'dio_client.g.dart';

// ── Timeout constants ──────────────────────────────────────────────────────────

const Duration _connectTimeout = Duration(seconds: 15);
const Duration _receiveTimeout = Duration(seconds: 30);
const Duration _sendTimeout = Duration(seconds: 15);

// ── Dio provider ──────────────────────────────────────────────────────────────

/// Provides a fully configured [Dio] instance.
///
/// Configuration:
/// - Base URL from [AppEnv.baseUrl] (set at build time via envied).
/// - Standard timeouts: connect 15 s, receive 30 s, send 15 s.
/// - `Content-Type: application/json` + optional `Authorization` header.
/// - [TalkerDioLogger] interceptor wired to the global [talker] instance.
///
/// [keepAlive: true] — Dio is stateless and safe to keep for the app lifetime.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Include the API key only when one is configured.
        if (AppEnv.apiKey.isNotEmpty)
          'Authorization': 'Bearer ${AppEnv.apiKey}',
      },
    ),
  );

  // Wire Talker as the Dio logger so all HTTP traffic appears in the
  // Talker console alongside Riverpod and router logs.
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
    ),
  );

  return dio;
}
