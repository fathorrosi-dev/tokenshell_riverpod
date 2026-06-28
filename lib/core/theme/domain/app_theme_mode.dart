/// Pure-Dart representation of the user's theme preference.
///
/// Exists so the Domain and Data layers (`IThemeModeRepository`,
/// `ThemeModeRepository`) never need to import `flutter/material.dart`
/// just to reference a theme value — `material.dart`'s `ThemeMode` is a
/// Flutter framework type, and Domain/Data must stay pure Dart, testable
/// without the Flutter SDK at all.
///
/// Convert to/from Flutter's `ThemeMode` only at the Presentation
/// boundary — see `app_theme_mode_extensions.dart`.
enum AppThemeMode {
  /// Follow the OS-level setting.
  system,
  light,
  dark,
}
