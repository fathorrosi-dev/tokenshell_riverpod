import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/theme/domain/app_theme_mode.dart';
import 'package:tokenshell_riverpod/core/theme/domain/i_theme_mode_repository.dart';

// Storage key is private to this file — no other layer should know about it.
const _kThemeModeKey = 'app_theme_mode';

/// SharedPreferences-backed implementation of [IThemeModeRepository].
///
/// All platform errors are caught here and converted to [Failure.cache] —
/// no exception ever leaks to the Notifier. This is the only class in the
/// codebase that is allowed to read/write the theme preference key.
///
/// The original exception is logged via [Talker] right here, at the catch
/// site — never carried inside the [Failure] itself. A [Failure] needs to
/// stay a stable value for equality (see `failure.dart`'s design note);
/// `e.toString()` is never the same twice, so it goes to the log, not the
/// failure's `message` field.
final class ThemeModeRepository implements IThemeModeRepository {
  const ThemeModeRepository(this._prefs, this._talker);

  final SharedPreferences _prefs;
  final Talker _talker;

  @override
  Either<Failure, AppThemeMode> read() {
    try {
      final raw = _prefs.getString(_kThemeModeKey);

      // Null (no value stored) is treated as system default — not an error.
      final mode = switch (raw) {
        'light' => AppThemeMode.light,
        'dark' => AppThemeMode.dark,
        _ => AppThemeMode.system,
      };
      return Right(mode);
    } on Exception catch (e, stackTrace) {
      // Platform channel errors surface here; Notifier falls back to system.
      _talker.handle(e, stackTrace, 'ThemeModeRepository.read failed');
      return const Left(Failure.cache());
    }
  }

  @override
  Future<Either<Failure, Unit>> write(AppThemeMode mode) async {
    try {
      final value = switch (mode) {
        AppThemeMode.light => 'light',
        AppThemeMode.dark => 'dark',
        AppThemeMode.system => 'system',
      };

      final success = await _prefs.setString(_kThemeModeKey, value);

      // SharedPreferences.setString() returns false on a write failure that
      // does NOT throw an exception — e.g. when the platform-side storage
      // quota is exhausted or the underlying commit returns false silently.
      // Ignoring this bool (the pre-fix behaviour) caused a silent
      // inconsistency: the optimistic UI update in ThemeModeNotifier would
      // never roll back, and no error would reach Sentry or Talker, so the
      // user would see their preference appear to save while it actually
      // hadn't. Returning Left here gives the Notifier the same rollback
      // path it already has for the exception case.
      if (!success) {
        _talker.warning(
          'ThemeModeRepository.write: setString() returned false '
          'for key "$_kThemeModeKey" — write did not persist. '
          'Possible cause: platform storage quota exceeded or disk full.',
        );
        return const Left(Failure.cache());
      }

      return const Right(unit);
    } on Exception catch (e, stackTrace) {
      // Write failures are returned as Left so callers can roll back any
      // optimistic UI update rather than silently leaving state inconsistent.
      _talker.handle(e, stackTrace, 'ThemeModeRepository.write failed');
      return const Left(Failure.cache());
    }
  }
}
