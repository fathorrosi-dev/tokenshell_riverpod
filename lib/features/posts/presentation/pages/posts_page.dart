import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tokenshell_riverpod/core/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/theme/app_theme_extension.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/notifiers/posts_notifier.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/widgets/post_card.dart';

/// Main posts list page.
///
// ignore: comment_references
/// Handles three async states via [AsyncValue.when]:
///   - loading  → centred [CircularProgressIndicator]
///   - error    → user-friendly error card with retry button
///   - data     → scrollable list of [PostCard] widgets
class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.read(postsProvider.notifier).refresh(),
          ),
          const SizedBox(width: SpacingTokens.sm),
        ],
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          failure: error is Failure ? error : null,
          rawError: error,
          onRetry: () => ref.read(postsProvider.notifier).refresh(),
        ),
        data: (posts) => posts.isEmpty
            ? _EmptyView(colors: colors)
            : ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: context.pagePadding.horizontal / 2,
                  vertical: SpacingTokens.xl,
                ),
                itemCount: posts.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: SpacingTokens.md),
                itemBuilder: (context, index) => PostCard(post: posts[index]),
              ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.colors});
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: colors.mutedForeground),
          const SizedBox(height: SpacingTokens.xl),
          Text(
            'No posts found.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.failure,
    required this.rawError,
    required this.onRetry,
  });

  final Failure? failure;
  final Object rawError;
  final VoidCallback onRetry;

  String get _message => failure?.message ?? rawError.toString();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.x3l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: colors.destructive,
            ),
            const SizedBox(height: SpacingTokens.xl),
            Text(
              'Something went wrong',
              style: context.textTheme.titleMedium?.copyWith(
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: SpacingTokens.sm),
            Text(
              _message,
              style: context.textTheme.bodySmall?.copyWith(
                color: colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingTokens.x3l),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try again'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
