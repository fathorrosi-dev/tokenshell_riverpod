import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/notifiers/theme_mode_notifier.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';

/// Home feature placeholder page.
///
/// Renders a live token preview so developers can verify the design system
/// is wired correctly before building actual feature UI.
///
/// ## Why ConsumerStatefulWidget (R16)
///
/// This page watches the same [themeModeWriteFailureProvider] as
/// [SettingsPage] (see its "Why ConsumerStatefulWidget (R4)" doc comment for
/// the full explanation), but was never migrated when that fix landed. A
/// [ConsumerWidget] using [WidgetRef.listen] inside `build()` has no
/// guaranteed cleanup point — if this widget is disposed between a write
/// failure being posted and the listener callback firing, the failure is
/// never cleared and can resurface as a stale SnackBar on the next visit.
/// [ref.listenManual] fixes this the same way it does in Settings: an
/// explicit [ProviderSubscription] closed in [dispose].
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ProviderSubscription<Object?> _writeFailureSub;

  @override
  void initState() {
    super.initState();

    // listenManual instead of ref.listen (which only runs inside build())
    // so the subscription can be closed explicitly in dispose(). Without
    // that, a failure posted after this widget leaves the tree would never
    // be cleared, and would surface as a spurious SnackBar the next time
    // Home is opened.
    _writeFailureSub = ref.listenManual<Object?>(
      themeModeWriteFailureProvider,
      (previous, failure) {
        if (failure == null) return;
        // Guard against the callback firing after dispose() has already
        // run (e.g. a fast back-gesture right as the failure is posted).
        // Without this, ScaffoldMessenger.of() would throw on a context
        // that is no longer in the tree.
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Couldn't save your theme preference. Try again."),
          ),
        );
        // Clear the failure so the same one isn't shown again on the next
        // build or re-visit.
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
    final themeMode = ref.watch(themeModeProvider).value;

    // Built once per State.build() call (exactly the same cost as the
    // previous `ListView(children: [...])`, which also constructed its
    // full children list on every build) and captured by the
    // itemBuilder closure below. Flutter's own lazy-materialization of
    // off-screen items is at the Element/RenderObject level, not at
    // this Widget-object level — see [_buildBodyItems]'s doc comment
    // for why this swap to `.builder` matters going forward even though
    // it changes nothing measurable today.
    final bodyItems = _buildBodyItems(context, colors);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text(AppStrings.homeAppBarTitle),
        actions: [
          // Theme mode toggle — cycles system → light → dark → system.
          IconButton(
            icon: Icon(_themeModeIcon(themeMode)),
            tooltip: AppStrings.homeToggleThemeTooltip,
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          const SizedBox(width: SpacingTokens.sm),
        ],
      ),
      body: ListView.builder(
        padding: context.pagePadding,
        itemCount: bodyItems.length,
        itemBuilder: (context, index) => bodyItems[index],
      ),
    );
  }

  /// Builds the flat list of body sections/rows fed to [ListView.builder]
  /// above.
  ///
  /// ## Why `.builder`, not `ListView(children: [...])` (LOW, 3 Jul 2026
  /// production readiness audit — Pillar 3)
  ///
  /// This page's content is currently static and small (~30 widgets) —
  /// switching delegate type buys no measurable performance difference
  /// for what's on screen today. The reason to make the switch now,
  /// rather than only once it's strictly needed: this page's own doc
  /// comment above describes it as a temporary placeholder meant to be
  /// replaced by real feature UI. `ListView(children: [...])` is exactly
  /// the pattern this app's own architecture treats as unsuitable once a
  /// list becomes real, data-driven, and potentially long (see
  /// `posts_page.dart`'s `ListView.separated` + `itemBuilder`) — leaving
  /// the old pattern here risked it getting copy-pasted forward the
  /// moment someone extends this "placeholder" instead of replacing it
  /// outright. Making the swap while it's still a no-op avoids that.
  ///
  /// The `Wrap` of color swatches stays as a single list item rather than
  /// being flattened into 13 separate ones — it's a flowing horizontal
  /// layout, not a vertical sequence, so splitting it up would change
  /// what's actually rendered, not just how it's delivered to the list.
  ///
  /// Takes [colors] explicitly (rather than re-reading `context.colors`)
  /// so this stays a pure function of its inputs — no risk of silently
  /// reading a stale/different [BuildContext] than the one [build] is
  /// currently working with.
  List<Widget> _buildBodyItems(BuildContext context, AppThemeColors colors) {
    return [
      Text(AppStrings.homeHeading, style: context.textTheme.headlineMedium),
      const SizedBox(height: SpacingTokens.sm),
      Text(
        AppStrings.homeSubheading,
        style: context.textTheme.bodyMedium?.copyWith(
          color: colors.mutedForeground,
        ),
      ),
      const SizedBox(height: SpacingTokens.x4l),

      // ── Color token swatch grid ──────────────────────────────────────
      // Swatch labels below ('background', 'primary', ...) are
      // intentionally NOT routed through AppStrings — see the "What's
      // deliberately NOT here" section of app_strings.dart. They name
      // actual design-token identifiers for a developer-facing preview,
      // not user-facing copy.
      Text(
        AppStrings.homeColorTokensSectionTitle,
        style: context.textTheme.titleMedium,
      ),
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

      // ── Typography scale preview ─────────────────────────────────────
      Text(
        AppStrings.homeTypographySectionTitle,
        style: context.textTheme.titleMedium,
      ),
      const SizedBox(height: SpacingTokens.xl),
      ..._buildTypographyRows(context),
      const SizedBox(height: SpacingTokens.x4l),
    ];
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
            border: Border.all(color: context.colors.border),
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
