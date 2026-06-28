import 'package:flutter/material.dart' as material;

import 'package:tokenshell_riverpod/core/theme/domain/app_theme_mode.dart';

/// Conversion between the pure-Dart [AppThemeMode] and Flutter's
/// [material.ThemeMode].
///
/// Lives in the Presentation layer on purpose — this is the only place in
/// the codebase allowed to know both types exist. Domain and Data only
/// ever see [AppThemeMode]; Notifiers and widgets convert at the boundary,
/// typically right where `MaterialApp(themeMode: ...)` is configured.
extension AppThemeModeX on AppThemeMode {
  material.ThemeMode toFlutterThemeMode() => switch (this) {
    AppThemeMode.system => material.ThemeMode.system,
    AppThemeMode.light => material.ThemeMode.light,
    AppThemeMode.dark => material.ThemeMode.dark,
  };
}

/// Reverse conversion — needed wherever a Settings UI uses a
/// Flutter-typed widget (e.g. a segmented control bound to `ThemeMode`)
/// and needs to call `ThemeModeNotifier.setThemeMode` with the Domain type.
extension FlutterThemeModeX on material.ThemeMode {
  AppThemeMode toAppThemeMode() => switch (this) {
    material.ThemeMode.system => AppThemeMode.system,
    material.ThemeMode.light => AppThemeMode.light,
    material.ThemeMode.dark => AppThemeMode.dark,
  };
}
