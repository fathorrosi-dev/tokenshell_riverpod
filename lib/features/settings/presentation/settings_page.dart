import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenshell_riverpod/core/di/package_info_provider.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/notifiers/theme_mode_notifier.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';

/// Settings feature placeholder page.
///
/// Provides theme mode controls and displays app metadata.
/// Extend this page with actual settings as features grow.
///
/// ## Why ConsumerStatefulWidget (R4)
///
/// The previous [ConsumerWidget] used [WidgetRef.listen] which runs in
/// `build()` — if the widget is disposed between the write failure being
/// posted and the listener callback firing, the failure is never cleared.
/// On the next visit to Settings the stale failure reappears as a spurious
/// error SnackBar, confusing the user.
///
/// [ref.listenManual] returns a [ProviderSubscription] that is explicitly
/// closed in [dispose], guaranteeing cleanup even when the user navigates
/// away quickly. The [mounted] guard inside the callback prevents
/// [ScaffoldMessenger.of] from being called on a detached context.
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final ProviderSubscription<Object?> _writeFailureSub;

  @override
  void initState() {
    super.initState();

    // listenManual is used instead of ref.listen (which only runs inside
    // build()) so we can close the subscription in dispose(). Without
    // explicit closure, a pending failure posted after this widget is
    // removed from the tree would not be cleared, and would surface as a
    // spurious SnackBar the next time the user opens Settings.
    _writeFailureSub = ref.listenManual<Object?>(
      themeModeWriteFailureProvider,
      (previous, failure) {
        if (failure == null) return;
        // Guard against the rare case where the callback fires after
        // dispose() has already run (e.g., a very fast back-gesture right
        // as the failure is posted). Without this, ScaffoldMessenger.of()
        // would throw because the context is no longer in the tree.
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Couldn't save your theme preference. Try again."),
          ),
        );
        // Clear the failure so the same one isn't shown again on the next
        // build or re-visit. Setting null here is what notifies any other
        // listeners that the failure has been consumed.
        ref.read(themeModeWriteFailureProvider.notifier).failure = null;
      },
    );
  }

  @override
  void dispose() {
    // Close the subscription so any pending failure posted after this point
    // is not processed by a dead callback referencing a disposed context.
    _writeFailureSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themeAsync = ref.watch(themeModeProvider);
    final packageInfoAsync = ref.watch(packageInfoProvider);
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
                      // IconSizeTokens.sm (16 px) keeps the icon tied to the
                      // token scale instead of a raw literal — if the token
                      // changes, all three icons here update automatically.
                      icon: Icon(
                        Icons.brightness_auto_outlined,
                        size: IconSizeTokens.sm,
                      ),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(
                        Icons.light_mode_outlined,
                        size: IconSizeTokens.sm,
                      ),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(
                        Icons.dark_mode_outlined,
                        size: IconSizeTokens.sm,
                      ),
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
                  // Local shape override removed (R6 / segmented button polish):
                  // ButtonThemeBuilder.segmentedButton() already sets the
                  // correct RadiusTokens.md shape in the theme — a redundant
                  // widget-level override here would silently shadow any future
                  // token update and was the only remaining raw-style reference
                  // in this file.
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
                _InfoRow(
                  label: 'Version',
                  value: packageInfoAsync.asData?.value.version ?? '—',
                ),
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

/// A card-shaped container that delegates ALL visual styling to [CardThemeData].
///
/// ## Why Card, not Container + BoxDecoration (R6)
///
/// The previous implementation hard-coded [colors.card], [colors.border], and
/// [RadiusTokens.lg] via manual [BoxDecoration]. This meant that any update
/// to [SurfaceThemeBuilder.card()] — changing the radius, elevation, or border
/// treatment — would NOT be reflected here, silently diverging from every other
/// [Card] in the app.
///
/// Using the [Card] widget instead makes [CardThemeData] the single source of
/// truth for this widget's appearance. The padding is the only thing kept here
/// because it is semantic to the Settings layout, not a card-level concern.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Card reads CardThemeData → SurfaceThemeBuilder.card() for color, shape,
    // elevation, border, and margin. Any token update propagates here for free.
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.xl),
        child: SizedBox(width: double.infinity, child: child),
      ),
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
