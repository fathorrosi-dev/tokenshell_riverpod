import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/theme/design_system/design_system.dart';
import 'package:tokenshell_riverpod/core/utils/extensions.dart';
import 'package:tokenshell_riverpod/features/posts/presentation/notifiers/post_detail_notifier.dart';
import 'package:tokenshell_riverpod/shared/widgets/app_state_view.dart';

/// Detail screen for a single post, reached from `PostCard`'s tap target.
///
/// Previously, `PostCard.onTap` had no real destination at all — the post
/// detail data layer (`PostRepository.getPostById`, the Retrofit endpoint)
/// already existed, but nothing in Presentation consumed it. This page is
/// the missing other end of that pipe.
class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({required this.postId, super.key});

  /// The post id resolved from the route's path parameter.
  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final postAsync = ref.watch(postDetailProvider(postId));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        // FIXED: was `Text('Post #$postId')` — hardcoded ID string regardless
        // of whether the post data had already loaded. This formed a bad
        // precedent for other detail pages (invoice, client, retainer log)
        // that would naturally want to show the item name in the AppBar.
        //
        // Now: shows 'Post #$postId' as a loading fallback, then updates to
        // the actual post title once the data resolves. Deep links benefit
        // from this too: the title is immediately correct if the post was
        // served from the cache-first path in PostDetailNotifier.
        //
        // postAsync.asData?.value.title is null-safe: if the post hasn't
        // loaded yet (loading/error state), we fall back to the ID string.
        title: Text(
          postAsync.asData?.value.title.capitalised ?? 'Post #$postId',
        ),
      ),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppStateView.error(
          message: error is Failure ? error.message : error.toString(),
          onRetry: () => ref.invalidate(postDetailProvider(postId)),
        ),
        data: (post) => SingleChildScrollView(
          padding: context.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title.capitalised,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: SpacingTokens.sm),
              Text(
                'User ${post.userId} · Post #${post.id}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: SpacingTokens.x3l),
              Text(
                post.body.capitalised,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: colors.foreground,
                  height: TypographyTokens.leadingRelaxed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
