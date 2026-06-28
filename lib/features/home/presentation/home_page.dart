import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/notifiers/theme_mode_notifier.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';

/// Home feature placeholder page.
///
/// Renders a live token preview so developers can verify the design system
/// is wired correctly before building actual feature UI.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final themeMode = ref.watch(themeModeProvider).value;

    // Surfaces theme-mode persistence failures instead of letting the
    // toggle above silently snap back with no explanation. See
    // [themeModeWriteFailureProvider] for why this lives outside
    // [ThemeModeNotifier]'s own state.
    ref.listen<Object?>(themeModeWriteFailureProvider, (previous, failure) {
      if (failure == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't save your theme preference. Try again."),
        ),
      );
      ref.read(themeModeWriteFailureProvider.notifier).failure = null;
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Theme mode toggle — cycles system → light → dark → system.
          IconButton(
            icon: Icon(
              _themeModeIcon(themeMode),
            ),
            tooltip: 'Toggle theme',
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          const SizedBox(width: SpacingTokens.sm),
        ],
      ),
      body: ListView(
        padding: context.pagePadding,
        children: [
          Text(
            'TokenShell Riverpod',
            style: context.textTheme.headlineMedium,
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            'shadcn/ui design tokens · Clean Architecture · Riverpod',
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.mutedForeground,
            ),
          ),
          const SizedBox(height: SpacingTokens.x4l),

          // ── Color token swatch grid ────────────────────────────────────────
          Text('Color Tokens', style: context.textTheme.titleMedium),
          const SizedBox(height: SpacingTokens.xl),
          Wrap(
            spacing: SpacingTokens.md,
            runSpacing: SpacingTokens.md,
            children: [
              _Swatch(
                label: 'background',
                color: colors.background,
                onColor: colors.foreground,
              ),
              _Swatch(
                label: 'foreground',
                color: colors.foreground,
                onColor: colors.background,
              ),
              _Swatch(
                label: 'card',
                color: colors.card,
                onColor: colors.cardForeground,
              ),
              _Swatch(
                label: 'primary',
                color: colors.primary,
                onColor: colors.primaryForeground,
              ),
              _Swatch(
                label: 'secondary',
                color: colors.secondary,
                onColor: colors.secondaryForeground,
              ),
              _Swatch(
                label: 'muted',
                color: colors.muted,
                onColor: colors.mutedForeground,
              ),
              _Swatch(
                label: 'accent',
                color: colors.accent,
                onColor: colors.accentForeground,
              ),
              _Swatch(
                label: 'destructive',
                color: colors.destructive,
                onColor: colors.destructiveForeground,
              ),
              _Swatch(
                label: 'border',
                color: colors.border,
                onColor: colors.foreground,
              ),
              _Swatch(
                label: 'success',
                color: colors.status.success,
                onColor: colors.status.successForeground,
              ),
              _Swatch(
                label: 'warning',
                color: colors.status.warning,
                onColor: colors.status.warningForeground,
              ),
              _Swatch(
                label: 'info',
                color: colors.status.info,
                onColor: colors.status.infoForeground,
              ),
              _Swatch(
                label: 'error',
                color: colors.status.error,
                onColor: colors.status.errorForeground,
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.x4l),

          // ── Typography scale preview ───────────────────────────────────────
          Text('Typography Scale', style: context.textTheme.titleMedium),
          const SizedBox(height: SpacingTokens.xl),
          ..._buildTypographyRows(context),
          const SizedBox(height: SpacingTokens.x4l),
        ],
      ),
    );
  }

  IconData _themeModeIcon(ThemeMode? mode) {
    return switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
      _ => Icons.brightness_auto_outlined,
    };
  }

  List<Widget> _buildTypographyRows(BuildContext context) {
    final tt = context.textTheme;
    final items = <(String, TextStyle?)>[
      ('displayLarge', tt.displayLarge),
      ('headlineMedium', tt.headlineMedium),
      ('titleLarge', tt.titleLarge),
      ('titleMedium', tt.titleMedium),
      ('bodyLarge', tt.bodyLarge),
      ('bodyMedium', tt.bodyMedium),
      ('bodySmall', tt.bodySmall),
      ('labelLarge', tt.labelLarge),
      ('labelSmall', tt.labelSmall),
    ];

    return [
      for (final (label, style) in items) ...[
        Text(label, style: style),
        const SizedBox(height: SpacingTokens.md),
      ],
    ];
  }
}

// ── Color swatch widget ────────────────────────────────────────────────────────

class _Swatch extends StatefulWidget {
  const _Swatch({
    required this.label,
    required this.color,
    required this.onColor,
  });

  final String label;
  final Color color;
  final Color onColor;

  @override
  State<_Swatch> createState() => _SwatchState();
}

class _SwatchState extends State<_Swatch> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    // Previously `_Swatch` was a plain [StatelessWidget] with no animation
    // at all — meaning [context.durations] (the reduce-motion-aware
    // duration system, see `core/utils/extensions.dart`) had zero real
    // consumers anywhere in this template, and its wiring to
    // [MediaQuery.disableAnimationsOf] had never actually been exercised.
    // This small press-scale affordance is a low-stakes way to prove it
    // works end-to-end: with OS-level "Reduce Motion" enabled,
    // `context.durations.fast` resolves to [Duration.zero] and this
    // animation becomes an instant, silent state change instead.
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: context.durations.fast,
        curve: Curves.easeOut,
        child: Container(
          width: 120,
          height: 56,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            border: Border.all(
              color: context.colors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: TypographyTokens.fontFamily,
              fontSize: TypographyTokens.sizeXs,
              fontWeight: TypographyTokens.weightMedium,
              color: widget.onColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
