import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/theme_constants.dart';

/// Produces fully-configured [ThemeData] for light and dark modes.
///
/// Both factory methods are pure functions: given the same token set
/// they always return the same [ThemeData]. Zero colors are hardcoded
/// here — every value is sourced from [ColorTokens] via [ThemeConstants].
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(),
///   darkTheme: AppTheme.dark(),
/// );
/// ```
abstract final class AppTheme {
  /// Returns a complete light-mode [ThemeData].
  static ThemeData light() => _build(
    colors: ThemeConstants.lightColors,
    brightness: Brightness.light,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  /// Returns a complete dark-mode [ThemeData].
  static ThemeData dark() => _build(
    colors: ThemeConstants.darkColors,
    brightness: Brightness.dark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ── Internal builder ──────────────────────────────────────────────────────────

  static ThemeData _build({
    required AppThemeColors colors,
    required Brightness brightness,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final colorScheme = ThemeConstants.colorSchemeFrom(colors, brightness);
    final textTheme = ThemeConstants.textThemeFrom(colors.foreground);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,

      // Register the shadcn/ui extension — required for AppThemeExtension.of(ctx)
      extensions: [AppThemeExtension(colors: colors)],

      // ── Scaffold ────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: colors.background,

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: systemOverlayStyle,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colors.foreground,
          fontWeight: TypographyTokens.weightSemiBold,
        ),
        iconTheme: IconThemeData(color: colors.foreground, size: 20),
        actionsIconTheme: IconThemeData(color: colors.foreground, size: 20),
        centerTitle: false,
      ),

      // ── Card ────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colors.card,
        shadowColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          side: BorderSide(color: colors.border),
        ),
      ),

      // ── Divider ─────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 0,
      ),
      dividerColor: colors.border,

      // ── Input decoration ─────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.xl,
          vertical: SpacingTokens.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.mutedForeground,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colors.mutedForeground,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: colors.foreground,
          fontWeight: TypographyTokens.weightMedium,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colors.destructive,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colors.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colors.input),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colors.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(color: colors.destructive, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          borderSide: BorderSide(
            color: colors.input.withValues(alpha: 0.5),
          ),
        ),
      ),

      // ── Elevated button (shadcn "default" / primary variant) ─────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.primary.withValues(alpha: 0.5);
            }
            return colors.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.primaryForeground.withValues(alpha: 0.5);
            }
            return colors.primaryForeground;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return colors.primaryForeground.withValues(alpha: 0.08);
            }
            if (states.contains(WidgetState.pressed)) {
              return colors.primaryForeground.withValues(alpha: 0.12);
            }
            return Colors.transparent;
          }),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RadiusTokens.md),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: SpacingTokens.xl,
              vertical: SpacingTokens.lg,
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(
              fontWeight: TypographyTokens.weightMedium,
            ),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(64, 40)),
        ),
      ),

      // ── Outlined button (shadcn "outline" variant) ───────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return colors.accent;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.foreground.withValues(alpha: 0.4);
            }
            return colors.foreground;
          }),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: colors.border.withValues(alpha: 0.5));
            }
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colors.ring, width: 2);
            }
            return BorderSide(color: colors.border);
          }),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RadiusTokens.md),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: SpacingTokens.xl,
              vertical: SpacingTokens.lg,
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(
              fontWeight: TypographyTokens.weightMedium,
            ),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(64, 40)),
        ),
      ),

      // ── Text button (shadcn "ghost" variant) ─────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return colors.accent;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colors.foreground.withValues(alpha: 0.4);
            }
            if (states.contains(WidgetState.hovered)) {
              return colors.accentForeground;
            }
            return colors.foreground;
          }),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RadiusTokens.md),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: SpacingTokens.xl,
              vertical: SpacingTokens.lg,
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(
              fontWeight: TypographyTokens.weightMedium,
            ),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(64, 40)),
        ),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colors.secondary,
        selectedColor: colors.primary,
        disabledColor: colors.muted,
        deleteIconColor: colors.mutedForeground,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colors.secondaryForeground,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colors.primaryForeground,
        ),
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.xs,
        ),
        elevation: 0,
        pressElevation: 0,
      ),

      // ── Dialog ───────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colors.popover,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          side: BorderSide(color: colors.border),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colors.popoverForeground,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.popoverForeground,
        ),
      ),

      // ── ListTile ─────────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: colors.accent,
        textColor: colors.foreground,
        selectedColor: colors.accentForeground,
        iconColor: colors.mutedForeground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.xl,
          vertical: SpacingTokens.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        titleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.foreground,
          fontWeight: TypographyTokens.weightMedium,
        ),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: colors.mutedForeground,
        ),
      ),

      // ── Navigation bar (bottom) ──────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        indicatorColor: colors.accent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colors.accentForeground,
              size: 22,
            );
          }
          return IconThemeData(
            color: colors.mutedForeground,
            size: 22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colors.foreground,
              fontWeight: TypographyTokens.weightSemiBold,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: colors.mutedForeground,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // ── Navigation rail ──────────────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.background,
        elevation: 0,
        indicatorColor: colors.accent,
        selectedIconTheme: IconThemeData(
          color: colors.accentForeground,
          size: 20,
        ),
        unselectedIconTheme: IconThemeData(
          color: colors.mutedForeground,
          size: 20,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.foreground,
          fontWeight: TypographyTokens.weightSemiBold,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.mutedForeground,
        ),
      ),

      // ── Switch ───────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.mutedForeground.withValues(alpha: 0.5);
          }
          if (states.contains(WidgetState.selected)) {
            return colors.primaryForeground;
          }
          return colors.mutedForeground;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.muted;
          }
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.input;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      // ── Checkbox ─────────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.muted;
          }
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(colors.primaryForeground),
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: colors.primary, width: 1.5);
          }
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: colors.muted, width: 1.5);
          }
          return BorderSide(color: colors.primary, width: 1.5);
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
        ),
      ),

      // ── Radio ────────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.mutedForeground.withValues(alpha: 0.4);
          }
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.mutedForeground;
        }),
      ),

      // ── Snack bar ────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.foreground,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.background,
        ),
        actionTextColor: colors.primary == colors.foreground
            ? colors.background.withValues(alpha: 0.7)
            : colors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Tooltip ──────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.popover,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
          boxShadow: ShadowTokens.sm,
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colors.popoverForeground,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.lg,
          vertical: SpacingTokens.sm,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),

      // ── Popup menu ───────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: colors.popover,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          side: BorderSide(color: colors.border),
        ),
        textStyle: textTheme.bodyMedium?.copyWith(
          color: colors.popoverForeground,
        ),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.bodyMedium?.copyWith(color: colors.popoverForeground),
        ),
        menuPadding: const EdgeInsets.symmetric(vertical: SpacingTokens.xs),
      ),

      // ── Bottom sheet ─────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        modalBackgroundColor: colors.card,
        modalElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(RadiusTokens.xl),
          ),
        ),
        dragHandleColor: colors.mutedForeground,
        dragHandleSize: const Size(32, 4),
        showDragHandle: true,
      ),

      // ── Progress indicator ───────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.muted,
        circularTrackColor: colors.muted,
        linearMinHeight: 4,
      ),

      // ── Tab bar ──────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: colors.foreground,
        unselectedLabelColor: colors.mutedForeground,
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: TypographyTokens.weightSemiBold,
        ),
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: TypographyTokens.weightRegular,
        ),
        dividerColor: colors.border,
        dividerHeight: 1,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colors.accent;
          }
          return Colors.transparent;
        }),
        splashFactory: NoSplash.splashFactory,
      ),

      // ── Drawer ───────────────────────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(RadiusTokens.lg),
            bottomRight: Radius.circular(RadiusTokens.lg),
          ),
        ),
      ),

      // ── Icons ────────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: colors.foreground,
        size: 20,
      ),
      primaryIconTheme: IconThemeData(
        color: colors.primaryForeground,
        size: 20,
      ),

      // ── FAB ──────────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.primaryForeground,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        splashColor: colors.primaryForeground.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
      ),

      // ── Splash / ink — minimal to keep shadcn feel ───────────────────────────
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: colors.accent.withValues(alpha: 0.5),
      focusColor: colors.ring.withValues(alpha: 0.12),
    );
  }
}
