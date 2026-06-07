import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/di/theme_provider.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';

/// Settings feature placeholder page.
///
/// Provides theme mode controls and displays app metadata.
/// Extend this page with actual settings as features grow.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final themeAsync = ref.watch(themeModeProvider);
    final currentMode = themeAsync.asData?.value ?? ThemeMode.system;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: context.pagePadding,
        children: [
          Text('Appearance', style: context.textTheme.titleMedium),
          const SizedBox(height: SpacingTokens.xl),

          // ── Theme mode selector ─────────────────────────────────────────────
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme mode',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.foreground,
                    fontWeight: TypographyTokens.weightMedium,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  'Controls whether the app uses the light or dark colour scheme.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xl),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined, size: 16),
                    ),
                  ],
                  selected: {currentMode},
                  onSelectionChanged: (modes) {
                    unawaited(
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(modes.first),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RadiusTokens.md),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: SpacingTokens.x3l),

          // ── Template metadata ───────────────────────────────────────────────
          Text('About', style: context.textTheme.titleMedium),
          const SizedBox(height: SpacingTokens.xl),
          _SectionCard(
            child: Column(
              children: [
                const _InfoRow(label: 'Template', value: 'TokenShell Riverpod'),
                Divider(height: SpacingTokens.x3l, color: colors.border),
                const _InfoRow(label: 'Flutter', value: '3.41'),
                Divider(height: SpacingTokens.x3l, color: colors.border),
                const _InfoRow(
                  label: 'Architecture',
                  value: 'Clean Architecture',
                ),
                Divider(height: SpacingTokens.x3l, color: colors.border),
                const _InfoRow(label: 'State', value: 'Riverpod'),
                Divider(height: SpacingTokens.x3l, color: colors.border),
                const _InfoRow(
                  label: 'Design system',
                  value: 'shadcn/ui tokens',
                ),
              ],
            ),
          ),

          const SizedBox(height: SpacingTokens.x4l),
        ],
      ),
    );
  }
}

// ── Shared layout widgets ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpacingTokens.xl),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.foreground,
            fontWeight: TypographyTokens.weightMedium,
          ),
        ),
      ],
    );
  }
}
