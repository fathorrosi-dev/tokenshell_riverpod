/// Contract for encrypted key-value storage operations.
///
/// ## Why an interface here?
///
/// Engineering Principle: every class that touches an external system must
/// have an interface in the domain/core layer so it can be mocked in tests.
/// [FlutterSecureStorage] is an external system (platform Keychain / Keystore).
/// Depending on it directly from a Repository or Notifier creates a hard
/// coupling that cannot be broken in unit tests without platform channels.
///
/// Features that need secure storage depend on this interface — never on
/// [SecureStorageDatasource] or [FlutterSecureStorage] directly. This keeps
/// the dependency arrow pointing inward: Auth feature → this interface ← impl.
///
/// ## Key conventions
///
/// Key naming: use dot-namespaced strings to prevent collisions across
/// features. Examples:
///   - 'auth.access_token'
///   - 'auth.refresh_token'
///   - 'biometric.enabled'
///
/// Values are always Strings. Callers that need to store structured data
/// should serialize to JSON before writing and deserialize after reading.
abstract interface class ISecureStorageDatasource {
  /// Reads the value stored under [key], or `null` if the key doesn't exist.
  Future<String?> read(String key);

  /// Writes [value] under [key], replacing any existing value.
  Future<void> write(String key, String value);

  /// Deletes the entry for [key]. No-op if the key doesn't exist.
  Future<void> delete(String key);

  /// Deletes all entries from secure storage.
  ///
  /// Use sparingly — intended for sign-out flows where the entire session
  /// (tokens, biometric flags, per-user prefs) must be wiped at once.
  Future<void> deleteAll();
}
