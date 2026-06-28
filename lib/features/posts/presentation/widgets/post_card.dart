import 'package:flutter/material.dart';
import 'package:tokenshell_riverpod/core/l10n/app_strings.dart';
import 'package:tokenshell_riverpod/core/routing/routes.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
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
          onTap: () => context.pushNamedRoute(
            AppRoute.postDetail.name,
            params: {'id': '${post.id}'},
          ),
          child: Padding(
            padding: const EdgeInsets.all(SpacingTokens.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row — post ID badge + user chip ───────────────────
                Row(
                  children: [
                    _Badge(
                      label: AppStrings.postCardIdBadge(post.id),
                      backgroundColor: colors.muted,
                      foregroundColor: colors.mutedForeground,
                    ),
                    const SizedBox(width: SpacingTokens.md),
                    _Badge(
                      label: AppStrings.postCardUserBadge(post.userId),
                      backgroundColor: colors.secondary,
                      foregroundColor: colors.secondaryForeground,
                    ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.xl),

                // ── Title ─────────────────────────────────────────────────────
                Text(
                  post.title.capitalised,
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
                      AppStrings.postCardReadMore,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.xs),
                    // FIXED: was `size: 14` — use token so this scales with
                    // future IconSizeTokens changes instead of silently
                    // diverging from the design system's xs definition.
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: IconSizeTokens.xs,
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
        // FIXED: was a hand-constructed TextStyle using raw TypographyTokens
        // literals (fontFamily, fontSize, fontWeight, letterSpacing). That
        // bypassed context.textTheme entirely, which means the fontSizeFactor
        // applied by App.builder at medium (×1.1) and expanded (×1.2)
        // breakpoints never reached badge text — it stayed compact-sized
        // regardless of breakpoint.
        //
        // Using textTheme.labelMedium as the base ensures the font size
        // participates in the responsive scaling pipeline. The font family,
        // size (sizeXs = 12 px), and weight (weightMedium) already match
        // the original badge intent — only color and letter-spacing are
        // overridden via copyWith.
        //
        // letterSpacing is explicitly reset to trackingNormal (0 px):
        // labelMedium defaults to trackingWide (0.4 px) from ThemeConstants,
        // which reads oddly for short identifier labels like '#1' or 'User 2'.
        style: context.textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          letterSpacing: TypographyTokens.trackingNormal,
        ),
      ),
    );
  }
}
