// dart run build_runner build --delete-conflicting-outputs
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tokenshell_riverpod/core/theme/app_theme.dart';

part 'theme_provider.g.dart';

// ── Constants ──────────────────────────────────────────────────────────────────

const _kThemeModeKey = 'app_theme_mode';

// ── SharedPreferences provider ─────────────────────────────────────────────────

/// Provides an already-initialised [SharedPreferences] instance.
///
/// Must be overridden in tests with a mock implementation.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

// ── Repository ─────────────────────────────────────────────────────────────────

/// Low-level read / write for the persisted [ThemeMode].
///
/// Kept separate from the notifier so it can be unit-tested independently
/// and swapped in integration tests without touching Riverpod state logic.
class ThemeModeRepository {
  const ThemeModeRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Reads the stored theme mode. Falls back to [ThemeMode.system] if absent.
  ThemeMode read() {
    final raw = _prefs.getString(_kThemeModeKey);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Persists [mode] to shared preferences.
  Future<void> write(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_kThemeModeKey, value);
  }
}

// ── Notifier ───────────────────────────────────────────────────────────────────

/// Async notifier that loads the persisted [ThemeMode] on first build,
/// exposes it to the widget tree, and persists changes via [ThemeModeRepository].
///
/// State lifecycle:
///   - loading → while [SharedPreferences] is being initialised.
///   - data    → the resolved [ThemeMode] (system / light / dark).
///   - error   → if prefs fails; UI falls back to [ThemeMode.system].
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  late ThemeModeRepository _repository;

  @override
  Future<ThemeMode> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    _repository = ThemeModeRepository(prefs);
    return _repository.read();
  }

  /// Switches to [mode] and persists it immediately.
  Future<void> setThemeMode(ThemeMode mode) async {
    // Optimistic local update so the UI responds instantly.
    state = AsyncData(mode);
    await _repository.write(mode);
  }

  /// Cycles through system → light → dark → system.
  Future<void> toggle() async {
    // Fix: use asData?.value instead of valueOrNull (Riverpod 3.x API).
    final current = state.asData?.value ?? ThemeMode.system;
    final next = switch (current) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(next);
  }
}

// ── ThemeData convenience providers ───────────────────────────────────────────

/// Provides the light [ThemeData] built from design tokens.
@Riverpod(keepAlive: true)
ThemeData lightTheme(Ref ref) => AppTheme.light();

/// Provides the dark [ThemeData] built from design tokens.
@Riverpod(keepAlive: true)
ThemeData darkTheme(Ref ref) => AppTheme.dark();
