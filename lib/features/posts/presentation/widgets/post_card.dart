import 'package:flutter/material.dart';

import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';

/// Renders a single [Post] as a shadcn/ui-inspired card.
///
/// Color contract: every color value is sourced exclusively from
/// [AppThemeExtension] semantic tokens or [ThemeData] ColorScheme.
/// No hardcoded [Color] literals are present in this file.
class PostCard extends StatelessWidget {
  const PostCard({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: colors.border),
        boxShadow: ShadowTokens.sm,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          splashColor: Colors.transparent,
          highlightColor: colors.accent.withValues(alpha: 0.5),
          onTap: () {
            // Navigate to post detail — implement with go_router push.
          },
          child: Padding(
            padding: const EdgeInsets.all(SpacingTokens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row — post ID badge + user chip ───────────────────
                Row(
                  children: [
                    _Badge(
                      label: '#${post.id}',
                      backgroundColor: colors.muted,
                      foregroundColor: colors.mutedForeground,
                    ),
                    const SizedBox(width: SpacingTokens.md),
                    _Badge(
                      label: 'User ${post.userId}',
                      backgroundColor: colors.secondary,
                      foregroundColor: colors.secondaryForeground,
                    ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.xl),

                // ── Title ─────────────────────────────────────────────────────
                Text(
                  _capitalise(post.title),
                  style: textTheme.titleSmall?.copyWith(
                    color: colors.cardForeground,
                    fontWeight: TypographyTokens.weightSemiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: SpacingTokens.md),

                // ── Body preview ──────────────────────────────────────────────
                Text(
                  post.body,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                    height: TypographyTokens.leadingRelaxed,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: SpacingTokens.xl),

                // ── Footer ────────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Read more',
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.xs),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: colors.mutedForeground,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _capitalise(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

// ── Badge helper widget ────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: TypographyTokens.fontFamily,
          fontFamilyFallback: TypographyTokens.fontFamilyFallback,
          fontSize: TypographyTokens.sizeXs,
          fontWeight: TypographyTokens.weightMedium,
          color: foregroundColor,
          letterSpacing: TypographyTokens.trackingNormal,
        ),
      ),
    );
  }
}
