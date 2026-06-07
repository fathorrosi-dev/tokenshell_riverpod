import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/theme_constants.dart';

void main() {
  group('AppTheme', () {
    // ── Light theme ────────────────────────────────────────────────────────────

    group('light()', () {
      test('produces correct background color from ColorTokens', () {
        // Arrange
        final theme = AppTheme.light();
        final extension = theme.extension<AppThemeExtension>();

        // Act
        final background = extension?.colors.background;

        // Assert
        expect(background, equals(ColorTokens.lightBackground));
      });

      test('produces correct primary color from ColorTokens', () {
        // Arrange
        final theme = AppTheme.light();
        final extension = theme.extension<AppThemeExtension>();

        // Act
        final primary = extension?.colors.primary;

        // Assert
        expect(primary, equals(ColorTokens.lightPrimary));
      });

      test('ColorScheme has no null critical fields', () {
        // Arrange
        final theme = AppTheme.light();
        final cs = theme.colorScheme;

        // Act / Assert — all critical ColorScheme fields must be non-null
        // (Dart non-nullable types enforce this, but we verify the values
        // are the exact tokens — not the Material 3 defaults)
        expect(cs.primary, equals(ColorTokens.lightPrimary));
        expect(cs.onPrimary, equals(ColorTokens.lightPrimaryForeground));
        expect(cs.error, equals(ColorTokens.lightDestructive));
        expect(cs.surface, equals(ColorTokens.lightBackground));
        expect(cs.onSurface, equals(ColorTokens.lightForeground));
        expect(cs.outline, equals(ColorTokens.lightBorder));
      });

      test('AppThemeExtension is registered in the theme', () {
        // Arrange
        final theme = AppTheme.light();

        // Act
        final extension = theme.extension<AppThemeExtension>();

        // Assert
        expect(extension, isNotNull);
      });
    });

    // ── Dark theme ─────────────────────────────────────────────────────────────

    group('dark()', () {
      test('produces correct background color from ColorTokens', () {
        // Arrange
        final theme = AppTheme.dark();
        final extension = theme.extension<AppThemeExtension>();

        // Act
        final background = extension?.colors.background;

        // Assert
        expect(background, equals(ColorTokens.darkBackground));
      });

      test('produces correct primary color from ColorTokens', () {
        // Arrange
        final theme = AppTheme.dark();
        final extension = theme.extension<AppThemeExtension>();

        // Act
        final primary = extension?.colors.primary;

        // Assert
        expect(primary, equals(ColorTokens.darkPrimary));
      });

      test('dark ColorScheme brightness is Brightness.dark', () {
        // Arrange / Act
        final theme = AppTheme.dark();

        // Assert
        expect(theme.colorScheme.brightness, equals(Brightness.dark));
      });
    });

    // ── Light / dark contrast ──────────────────────────────────────────────────

    test('light and dark backgrounds are different colors', () {
      // Arrange
      final light = AppTheme.light().extension<AppThemeExtension>();
      final dark = AppTheme.dark().extension<AppThemeExtension>();

      // Act / Assert
      expect(light?.colors.background, isNot(equals(dark?.colors.background)));
    });

    // ── AppThemeExtension lerp ─────────────────────────────────────────────────

    group('AppThemeExtension.lerp()', () {
      test('returns start value when t == 0.0', () {
        // Arrange
        const start = AppThemeExtension(colors: ThemeConstants.lightColors);
        const end = AppThemeExtension(colors: ThemeConstants.darkColors);

        // Act
        final result = start.lerp(end, 0);

        // Assert
        expect(
          result.colors.background,
          equals(ThemeConstants.lightColors.background),
        );
      });

      test('returns end value when t == 1.0', () {
        // Arrange
        const start = AppThemeExtension(colors: ThemeConstants.lightColors);
        const end = AppThemeExtension(colors: ThemeConstants.darkColors);

        // Act
        final result = start.lerp(end, 1);

        // Assert
        expect(
          result.colors.background,
          equals(ThemeConstants.darkColors.background),
        );
      });

      test('returns interpolated color at t == 0.5', () {
        // Arrange
        const start = AppThemeExtension(colors: ThemeConstants.lightColors);
        const end = AppThemeExtension(colors: ThemeConstants.darkColors);

        // Act
        final result = start.lerp(end, 0.5);
        final expected = Color.lerp(
          ThemeConstants.lightColors.background,
          ThemeConstants.darkColors.background,
          0.5,
        );

        // Assert
        expect(result.colors.background, equals(expected));
      });

      test('returns this when other is not AppThemeExtension', () {
        // Arrange
        const ext = AppThemeExtension(colors: ThemeConstants.lightColors);

        // Act
        final result = ext.lerp(null, 0.5);

        // Assert
        expect(result, equals(ext));
      });
    });

    // ── AppThemeColors copyWith ────────────────────────────────────────────────

    test('AppThemeColors.copyWith overrides only specified fields', () {
      // Arrange
      const original = ThemeConstants.lightColors;

      // Act
      final modified = original.copyWith(
        primary: ColorTokens.lightDestructive,
      );

      // Assert
      expect(modified.primary, equals(ColorTokens.lightDestructive));
      // All other fields remain unchanged
      expect(modified.background, equals(original.background));
      expect(modified.foreground, equals(original.foreground));
      expect(modified.border, equals(original.border));
    });
  });
}
