/// Barrel for the Logging subsystem.
///
/// Exported as a whole from `core/di/providers.dart` — add new Logging
/// provider/type files here, in the same folder you're already editing,
/// rather than remembering to also touch the distant top-level barrel.
/// See `core/di/providers.dart`'s doc comment for the drift problem this
/// folder-local barrel exists to avoid.
library;

// LogLevelPolicy — static-only, no codegen. Exported here so
// `dio_client.dart` can reach it via this barrel like everything else in
// the Network subsystem reaches Logging.
export 'log_level_policy.dart';
// talkerProvider only — the raw `talker` global is intentionally NOT
// re-exported here. It exists solely for `setupGlobalErrorHandling()` in
// `main.dart`, which runs before `ProviderScope` is mounted and therefore
// has no `Ref` to read from yet. Every other call site should go through
// `talkerProvider` so it stays mockable in tests.
export 'talker_provider.dart' show talkerProvider;
