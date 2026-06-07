import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokenshell_riverpod/core/di/theme_provider.dart';

// ── Mocks ──────────────────────────────────────────────────────────────────────

class _MockSharedPreferences extends Mock implements SharedPreferences {}

// ── Helpers ────────────────────────────────────────────────────────────────────

/// Builds a [ProviderContainer] with [SharedPreferences] overridden by [prefs].
ProviderContainer _makeContainer(SharedPreferences prefs) {
  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((_) async => prefs),
    ],
  );
}

void main() {
  late _MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = _MockSharedPreferences();
  });

  group('ThemeModeNotifier', () {
    test(
      'defaults to ThemeMode.system when SharedPreferences has no stored value',
      () async {
        // Arrange
        when(() => mockPrefs.getString('app_theme_mode')).thenReturn(null);
        final container = _makeContainer(mockPrefs);
        addTearDown(container.dispose);

        // Act
        final mode = await container.read(
          themeModeProvider.future,
        );

        // Assert
        expect(mode, equals(ThemeMode.system));
      },
    );

    test(
      'defaults to ThemeMode.light when "light" is stored in SharedPreferences',
      () async {
        // Arrange
        when(() => mockPrefs.getString('app_theme_mode')).thenReturn('light');
        final container = _makeContainer(mockPrefs);
        addTearDown(container.dispose);

        // Act
        final mode = await container.read(
          themeModeProvider.future,
        );

        // Assert
        expect(mode, equals(ThemeMode.light));
      },
    );

    test(
      'reads persisted ThemeMode.dark correctly on initialization',
      () async {
        // Arrange
        when(() => mockPrefs.getString('app_theme_mode')).thenReturn('dark');
        final container = _makeContainer(mockPrefs);
        addTearDown(container.dispose);

        // Act
        final mode = await container.read(
          themeModeProvider.future,
        );

        // Assert
        expect(mode, equals(ThemeMode.dark));
      },
    );

    test(
      'persists ThemeMode.dark after setThemeMode(ThemeMode.dark) is called',
      () async {
        // Arrange
        when(() => mockPrefs.getString('app_theme_mode')).thenReturn(null);
        when(
          () => mockPrefs.setString('app_theme_mode', any()),
        ).thenAnswer((_) async => true);

        final container = _makeContainer(mockPrefs);
        addTearDown(container.dispose);

        // Ensure the notifier is fully initialized before calling setThemeMode.
        await container.read(themeModeProvider.future);

        // Act
        await container
            .read(themeModeProvider.notifier)
            .setThemeMode(ThemeMode.dark);

        // Assert — SharedPreferences must have been called with 'dark'
        verify(() => mockPrefs.setString('app_theme_mode', 'dark')).called(1);

        // And the in-memory state must reflect the new value immediately
        final currentState =
            container.read(themeModeProvider).asData?.value;
        expect(currentState, equals(ThemeMode.dark));
      },
    );

    test(
      'toggle cycles system → light → dark → system in order',
      () async {
        // Arrange — start from system (no stored value)
        when(() => mockPrefs.getString('app_theme_mode')).thenReturn(null);
        when(
          () => mockPrefs.setString('app_theme_mode', any()),
        ).thenAnswer((_) async => true);

        final container = _makeContainer(mockPrefs);
        addTearDown(container.dispose);
        await container.read(themeModeProvider.future);

        final notifier =
            container.read(themeModeProvider.notifier);

        // Act & Assert — system → light
        await notifier.toggle();
        expect(
          container.read(themeModeProvider).asData?.value,
          equals(ThemeMode.light),
        );

        // Act & Assert — light → dark
        await notifier.toggle();
        expect(
          container.read(themeModeProvider).asData?.value,
          equals(ThemeMode.dark),
        );

        // Act & Assert — dark → system
        await notifier.toggle();
        expect(
          container.read(themeModeProvider).asData?.value,
          equals(ThemeMode.system),
        );
      },
    );
  });
}
