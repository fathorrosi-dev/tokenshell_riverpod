import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/network/offline_provider.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';
import 'package:tokenshell_riverpod/core/utils/responsive_helper.dart';
import 'package:tokenshell_riverpod/shared/shell/nav_destinations.dart';

/// Root adaptive shell widget.
///
/// Layout per [ScreenSizeClass]:
/// - [ScreenSizeClass.compact]  → [BottomNavigationBar] (no rail/drawer)
/// - [ScreenSizeClass.medium]   → [NavigationRail] collapsed (icons only)
/// - [ScreenSizeClass.expanded] → Persistent [NavigationRail] with labels
///
/// This widget never references `Platform.isAndroid`, `Platform.isIOS`,
/// or any device-type strings. Layout is driven purely by screen width.
///
/// ## Connectivity UI
///
/// [AppShell] watches [isOfflineProvider] and injects an [_OfflineBanner]
/// at the top of the active page whenever the device has no active adapter.
///
/// [isOfflineProvider] is a derived boolean — it collapses the raw
/// [connectivityStreamProvider] stream into a single flag and only notifies
/// listeners when that flag actually changes (R-08, 27 Jun 2026). The
/// previous approach watched [connectivityStreamProvider] directly, which
/// rebuilt this root shell widget on every adapter event — including
/// WiFi → cellular transitions that left the device online and changed
/// nothing visible. As the root of the navigation shell (wrapping
/// [NavigationBar] / [NavigationRail] and the entire active page), that
/// was unnecessary overhead.
///
/// The banner is injected into the *child* passed to each shell variant
/// rather than into each variant's [Scaffold.appBar], so no changes are
/// needed in [_CompactShell] or [_RailShell].
class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  /// The active page widget injected by go_router's [ShellRoute].
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Derived boolean — rebuilds AppShell only when online/offline flips,
    // not on every raw connectivity stream emission.
    final isOffline = ref.watch(isOfflineProvider);

    // Wrap child with the offline banner only when necessary — avoids
    // an unnecessary Column wrapper in the common (online) case.
    final effectiveChild = isOffline
        ? _OfflineBannerWrapper(child: child)
        : child;

    return switch (context.sizeClass) {
      ScreenSizeClass.compact => _CompactShell(child: effectiveChild),
      ScreenSizeClass.medium => _RailShell(
        expanded: false,
        child: effectiveChild,
      ),
      ScreenSizeClass.expanded => _RailShell(
        expanded: true,
        child: effectiveChild,
      ),
    };
  }
}

// ── Offline indicator ─────────────────────────────────────────────────────────

/// Wraps [child] with a non-dismissible offline status bar at the top.
///
/// Non-dismissible by design: the banner disappears automatically when
/// [connectivityStreamProvider] emits a connected result. Giving the user
/// a "dismiss" action would let them hide a problem that hasn't been
/// resolved yet, leading to confusing silent failures on the next
/// network request.
class _OfflineBannerWrapper extends StatelessWidget {
  const _OfflineBannerWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.xl,
            vertical: SpacingTokens.sm,
          ),
          color: colors.status.warning,
          child: Row(
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: IconSizeTokens.sm,
                color: colors.status.warningForeground,
              ),
              const SizedBox(width: SpacingTokens.sm),
              Text(
                // Was a hardcoded literal — AppStrings.shellOfflineBanner
                // exists specifically for this call site (see its doc
                // comment), but had never actually been wired up here.
                // Fixed so future i18n retrofits don't miss this string.
                AppStrings.shellOfflineBanner,
                style: context.textTheme.labelMedium?.copyWith(
                  color: colors.status.warningForeground,
                  // Reset letterSpacing to Normal: labelMedium uses trackingWide
                  // (0.4 px) by default, which reads oddly for sentence-case copy.
                  letterSpacing: TypographyTokens.trackingNormal,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────

/// Returns the index of the currently active destination, or 0 as fallback.
int _selectedIndex(BuildContext context) {
  final location = GoRouterState.of(context).matchedLocation;
  final index = appNavDestinations.indexWhere(
    (d) => location == d.path || location.startsWith('${d.path}/'),
  );
  return index < 0 ? 0 : index;
}

/// Navigates to the destination at [index] using go_router's `go` method
/// so that the browser history / deep-link stack is replaced, not pushed.
void _onDestinationSelected(BuildContext context, int index) {
  final destination = appNavDestinations[index];
  context.go(destination.path);
}

// ── Compact layout — BottomNavigationBar ──────────────────────────────────────

class _CompactShell extends StatelessWidget {
  const _CompactShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIdx = _selectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIdx,
        onDestinationSelected: (i) => _onDestinationSelected(context, i),
        // Styling (backgroundColor, surfaceTintColor, shadowColor, elevation,
        // indicatorColor, labelBehavior) is owned by NavigationThemeBuilder —
        // widget-level overrides removed to preserve single source of truth.
        destinations: [
          for (final dest in appNavDestinations)
            NavigationDestination(
              icon: Icon(dest.icon),
              selectedIcon: Icon(dest.selectedIcon),
              label: dest.label,
            ),
        ],
      ),
    );
  }
}

// ── Medium & Expanded layout — NavigationRail, parameterized by breakpoint ────

/// Shared rail-based shell for both the Medium and Expanded breakpoints.
///
/// The two breakpoints used to be near-identical separate widget classes
/// (`_MediumShell`, `_ExpandedShell`) differing only in label visibility,
/// rail width, and label text style — a real drift risk, since any rail
/// styling tweak had to be applied in two places. Consolidated here behind
/// a single [expanded] flag instead.
class _RailShell extends StatelessWidget {
  const _RailShell({required this.child, required this.expanded});

  final Widget child;

  /// `true` for the Expanded breakpoint (labels shown, wider rail, leading
  /// spacer). `false` for Medium (icons only, narrower rail).
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedIdx = _selectedIndex(context);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIdx,
            onDestinationSelected: (i) => _onDestinationSelected(context, i),
            // backgroundColor, indicatorColor, selectedIconTheme,
            // unselectedIconTheme, selectedLabelTextStyle, and
            // unselectedLabelTextStyle are intentionally NOT set here — they
            // are owned by NavigationThemeBuilder.navigationRail() in the
            // ThemeData. Setting them at the widget level (the previous
            // approach) silently shadowed the theme, meaning any token update
            // in NavigationThemeBuilder would have no visible effect in the
            // running app.
            //
            // Only the three properties that are genuinely conditional on the
            // [expanded] breakpoint flag belong here — everything else is the
            // theme's responsibility.
            labelType: expanded
                ? NavigationRailLabelType.all
                : NavigationRailLabelType.none,
            minWidth: expanded ? SpacingTokens.x9l : SpacingTokens.x7l,
            // Spacer only in expanded mode — keeps icons vertically centred
            // in the collapsed rail without adding dead space below the
            // app bar.
            leading: expanded ? const SizedBox(height: SpacingTokens.md) : null,
            destinations: [
              for (final dest in appNavDestinations)
                NavigationRailDestination(
                  icon: Icon(dest.icon),
                  selectedIcon: Icon(dest.selectedIcon),
                  label: Text(dest.label),
                  padding: const EdgeInsets.symmetric(
                    vertical: SpacingTokens.xs,
                  ),
                ),
            ],
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colors.border,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
