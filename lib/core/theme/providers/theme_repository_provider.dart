import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tokenshell_riverpod/core/di/shared_preferences_provider.dart';
import 'package:tokenshell_riverpod/core/logging/talker_provider.dart';
import 'package:tokenshell_riverpod/core/theme/data/theme_mode_repository.dart';
import 'package:tokenshell_riverpod/core/theme/domain/i_theme_mode_repository.dart';

part 'theme_repository_provider.g.dart';

/// Provides a fully-constructed [IThemeModeRepository]
/// backed by [SharedPreferences].
///
/// Exposing the return type as the interface rather than the concrete
/// implementation allows tests to override this provider with any
/// [IThemeModeRepository] implementation without changing consumers.
@Riverpod(keepAlive: true)
Future<IThemeModeRepository> themeModeRepository(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final talker = ref.watch(talkerProvider);

  return ThemeModeRepository(prefs, talker);
}
