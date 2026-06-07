import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
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
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  /// The active page widget injected by go_router's [ShellRoute].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (context.sizeClass) {
      ScreenSizeClass.compact => _CompactShell(child: child),
      ScreenSizeClass.medium => _MediumShell(child: child),
      ScreenSizeClass.expanded => _ExpandedShell(child: child),
    };
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
    final colors = context.colors;
    final selectedIdx = _selectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIdx,
        onDestinationSelected: (i) => _onDestinationSelected(context, i),
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        indicatorColor: colors.accent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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

// ── Medium layout — NavigationRail collapsed (icons only) ─────────────────────

class _MediumShell extends StatelessWidget {
  const _MediumShell({required this.child});
  final Widget child;

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
            backgroundColor: colors.background,
            // Icons only — labels hidden in medium breakpoint.
            labelType: NavigationRailLabelType.none,
            minWidth: 56,
            indicatorColor: colors.accent,
            selectedIconTheme: IconThemeData(
              color: colors.accentForeground,
              size: 22,
            ),
            unselectedIconTheme: IconThemeData(
              color: colors.mutedForeground,
              size: 22,
            ),
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

// ── Expanded layout — Persistent NavigationRail with labels ───────────────────

class _ExpandedShell extends StatelessWidget {
  const _ExpandedShell({required this.child});
  final Widget child;

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
            backgroundColor: colors.background,
            // Labels shown in expanded breakpoint.
            labelType: NavigationRailLabelType.all,
            minWidth: 80,
            indicatorColor: colors.accent,
            selectedIconTheme: IconThemeData(
              color: colors.accentForeground,
              size: 22,
            ),
            unselectedIconTheme: IconThemeData(
              color: colors.mutedForeground,
              size: 22,
            ),
            selectedLabelTextStyle: context.textTheme.labelMedium?.copyWith(
              color: colors.foreground,
              fontWeight: TypographyTokens.weightSemiBold,
            ),
            unselectedLabelTextStyle: context.textTheme.labelMedium?.copyWith(
              color: colors.mutedForeground,
            ),
            leading: const SizedBox(height: SpacingTokens.md),
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
