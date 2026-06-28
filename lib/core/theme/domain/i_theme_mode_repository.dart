import 'package:fpdart/fpdart.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/theme/domain/app_theme_mode.dart';

/// Contract for any persistence backend that stores and retrieves
/// [AppThemeMode].
///
/// Lives in the Domain layer so the Notifier depends only on this
/// abstraction — never on SharedPreferences or any other concrete storage
/// technology. Swapping from SharedPreferences to a cloud-synced
/// preference later requires only a new implementation, not a change to
/// the Notifier or business logic.
///
/// Uses [AppThemeMode] rather than Flutter's `ThemeMode` — this interface
/// and its implementation must stay pure Dart, testable without the
/// Flutter SDK. Conversion to Flutter's `ThemeMode` happens only at the
/// Presentation boundary, in `app_theme_mode_extensions.dart`.
abstract interface class IThemeModeRepository {
  /// Reads the persisted [AppThemeMode].
  ///
  /// Returns [Right] with the stored value, or
  /// [Right(AppThemeMode.system)] if no value has been written yet
  /// (first-launch default).
  /// Returns [Left] with a [Failure] — in practice always
  /// [Failure.cache] — only when the underlying storage raises an
  /// unexpected platform error.
  Either<Failure, AppThemeMode> read();

  /// Persists [mode] to the underlying storage.
  ///
  /// Returns [Right(unit)] on success.
  /// Returns [Left] with a [Failure] if the write fails so callers can
  /// decide whether to surface it or silently roll back an optimistic
  /// update.
  Future<Either<Failure, Unit>> write(AppThemeMode mode);
}
