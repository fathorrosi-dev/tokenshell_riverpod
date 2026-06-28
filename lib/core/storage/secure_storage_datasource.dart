// dart run build_runner build --delete-conflicting-outputs
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tokenshell_riverpod/core/storage/i_secure_storage_datasource.dart';
import 'package:tokenshell_riverpod/core/storage/secure_storage_provider.dart';

part 'secure_storage_datasource.g.dart';

/// [FlutterSecureStorage]-backed implementation of [ISecureStorageDatasource].
///
/// All platform-specific behaviour (Keychain on iOS, Keystore on Android,
/// libsecret on Linux) is handled by [FlutterSecureStorage] internally.
/// This class is a thin, testable wrapper that maps the plugin API to the
/// interface contract — keeping the surface area small and easy to mock.
///
/// Access this via [secureStorageDatasourceProvider], never by constructing
/// it directly.
final class SecureStorageDatasource implements ISecureStorageDatasource {
  const SecureStorageDatasource(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Provides the app's [ISecureStorageDatasource] instance.
///
/// Returns the interface type — consumers never need to know they're talking
/// to [SecureStorageDatasource] specifically. This keeps the provider
/// overridable in tests:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     secureStorageDatasourceProvider.overrideWithValue(
///       FakeSecureStorageDatasource(),
///     ),
///   ],
/// )
/// ```
///
/// [keepAlive: true] — storage is an app-lifetime infrastructure dependency.
/// Disposing and recreating it between screen transitions would be wasteful.
@Riverpod(keepAlive: true)
ISecureStorageDatasource secureStorageDatasource(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return SecureStorageDatasource(storage);
}
