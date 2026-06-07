// dart run build_runner build --delete-conflicting-outputs
import 'package:envied/envied.dart';

part 'app_env.g.dart';

/// Application environment variables loaded at build time via [envied].
///
/// Values are read from the `.env` file at the project root (never committed).
/// Developers must copy `.env.example` → `.env` and fill in real values.
///
/// [obfuscate: true] on sensitive fields prevents the raw string from
/// appearing in the compiled binary's symbol table.
@Envied(path: '.env')
abstract final class AppEnv {
  /// Base URL for the REST API (e.g. https://jsonplaceholder.typicode.com).
  @EnviedField(
    varName: 'BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  )
  static const String baseUrl = _AppEnv.baseUrl;

  /// Optional API key sent as an Authorization header.
  /// Obfuscated so the raw value is not stored as a plain string in the binary.
  @EnviedField(varName: 'API_KEY', defaultValue: '', obfuscate: true)
  static final String apiKey = _AppEnv.apiKey;
}
