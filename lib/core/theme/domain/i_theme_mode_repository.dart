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
  ///
  /// Deliberately **synchronous** — not `Future<Either<...>>` — even
  /// though [write] below is async. This is safe today because the
  /// current [SharedPreferences] instance is already resolved
  /// asynchronously *upstream*, at the provider level
  /// (`themeModeRepositoryProvider`, via `sharedPreferencesProvider.future`)
  /// before any [IThemeModeRepository] implementation is even constructed
  /// — so by the time [read] can be called, the underlying storage handle
  /// is already synchronously available in memory. A future implementation
  /// with genuinely async per-call I/O (e.g. a remote-synced or encrypted
  /// preference store queried live rather than cached) would need to
  /// either front-load that I/O the same way, or this contract would need
  /// to become async — noted here so that tradeoff is a deliberate choice,
  /// not a surprise, for whoever implements it.
  Either<Failure, AppThemeMode> read();

  /// Persists [mode] to the underlying storage.
  ///
  /// Returns [Right(unit)] on success.
  /// Returns [Left] with a [Failure] if the write fails so callers can
  /// decide whether to surface it or silently roll back an optimistic
  /// update.
  Future<Either<Failure, Unit>> write(AppThemeMode mode);
}
