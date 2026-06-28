import 'package:flutter/material.dart';

import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';

/// Shared full-bleed state view for empty, error, and not-found states.
///
/// Before this widget existed, the same
/// icon + title + message + optional action layout was hand-rolled three
/// times with slightly different code: `_EmptyView` and `_ErrorView` in
/// `posts_page.dart`, and the body of `_NotFoundPage` in `app_router.dart`
/// (whose own comment already admitted it "mirrors the look of `_ErrorView`
/// ... for visual consistency"). One widget now owns that layout —
/// call sites only supply content.
///
/// Note: the previous `_EmptyView` rendered a single, unstyled line with no
/// heading. [AppStateView.empty] intentionally renders a `titleMedium`
/// heading like the error/not-found states do, trading a small visual
/// change for one consistent typographic language across all three states.
class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    super.key,
  });

  /// Empty-list state — "nothing to show, but nothing went wrong."
  factory AppStateView.empty({
    String title = 'Nothing here yet',
    String? message,
  }) {
    return AppStateView(
      icon: Icons.inbox_outlined,
      title: title,
      message: message,
    );
  }

  /// Error state — something failed, with an optional retry action.
  factory AppStateView.error({
    required String message,
    String title = 'Something went wrong',
    String actionLabel = 'Try again',
    VoidCallback? onRetry,
    Color? iconColor,
  }) {
    return AppStateView(
      icon: Icons.cloud_off_rounded,
      title: title,
      message: message,
      actionLabel: onRetry != null ? actionLabel : null,
      onAction: onRetry,
      iconColor: iconColor,
    );
  }

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.x3l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor ?? colors.mutedForeground),
            const SizedBox(height: SpacingTokens.xl),
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: colors.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: SpacingTokens.sm),
              Text(
                message!,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: SpacingTokens.x3l),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(actionLabel!),
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
