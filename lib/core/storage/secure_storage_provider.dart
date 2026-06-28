// dart run build_runner build --delete-conflicting-outputs
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

/// Provides an initialized [FlutterSecureStorage] instance.
///
/// ## Why a provider instead of a const / singleton?
///
/// Identical rationale to [sharedPreferencesProvider]: keeping the storage
/// instance inside the Riverpod graph makes it overridable in tests
/// (`ProviderScope.overrides`), avoids module-level singletons that
/// survive between test runs, and makes it inspectable in Riverpod
/// DevTools.
///
/// [keepAlive: true] — the plugin instance is stateless and cheap to hold.
/// Disposing it on provider refresh would just recreate an identical object.
///
/// ## Android encryption
///
/// Previously, Android required explicitly enabling EncryptedSharedPreferences.
/// However, Google has deprecated the Jetpack Security library. Modern
/// versions of `flutter_secure_storage` now use custom ciphers by default
/// and automatically migrate legacy data. We no longer need to pass
/// `AndroidOptions(encryptedSharedPreferences: true)` as it is deprecated
/// and ignored by the plugin.
///
/// ## iOS — Keychain accessibility (R-09, 27 Jun 2026)
///
/// Explicitly set to [KeychainAccessibility.first_unlock_this_device].
///
/// The default ([KeychainAccessibility.unlocked]) allows iCloud Keychain
/// to sync stored values across devices signed into the same Apple ID.
/// For session tokens and auth credentials, cross-device sync is a
/// security concern: a token issued to an iPhone session would
/// silently appear on an iPad, creating an unexpected persistent session
/// on the second device without any login action there.
///
/// [first_unlock_this_device] restricts tokens to the current device and
/// the current device's hardware key, so:
/// - No iCloud Keychain sync.
/// - Value is also NOT migrated to a new device via encrypted backup
///   (unlike [KeychainAccessibility.first_unlock_this_device] + backup flag).
///   Users re-authenticate after a device restore — correct behavior for
///   session tokens.
///
/// If background token access is ever required (e.g. a silent push
/// handler that refreshes tokens while the app is backgrounded), revisit
/// this to use [KeychainAccessibility.afterFirstUnlock] with careful
/// justification, as it is less restrictive.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    // Android: custom cipher encryption handled automatically by the
    // plugin — no explicit AndroidOptions needed (see doc comment above).
    //
    // iOS: device-bound, no iCloud Keychain sync (see doc comment above).
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}
