/// Barrel for the Theme subsystem.
///
/// Exported as a whole from `core/di/providers.dart` — add new Theme
/// provider/type files here, in the same folder you're already editing,
/// rather than remembering to also touch the distant top-level barrel.
/// See `core/di/providers.dart`'s doc comment for the drift problem this
/// folder-local barrel exists to avoid.
///
/// `builders/`, `domain/`, `data/`, and `theme_constants.dart` are
/// deliberately NOT exported here — they're implementation details of
/// `app_theme.dart`/the providers below, not meant to be constructed or
/// called directly from outside this subsystem.
library;

export 'notifiers/theme_mode_notifier.dart';
// Exported without a `show` clause: generated provider names
// (themeModeProvider, lightThemeProvider, darkThemeProvider) are produced
// by build_runner and not visible to the analyzer until codegen runs —
// a `show` clause would cause analysis errors before the first build.
export 'providers/theme_data_provider.dart';
export 'providers/theme_repository_provider.dart';
