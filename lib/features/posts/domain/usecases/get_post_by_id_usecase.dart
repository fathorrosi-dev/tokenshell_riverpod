import 'package:fpdart/fpdart.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/domain/repositories/post_repository.dart';

/// Retrieves a single post by its [id].
///
/// Mirrors `GetPostsUseCase` — a use case encapsulates exactly one business
/// action and depends only on the abstract [PostRepository], never on a
/// concrete data class. This was previously missing even though
/// [PostRepository.getPostById] was already fully implemented, leaving the
/// Repository → UseCase → Notifier convention incomplete for this one path.
final class GetPostByIdUseCase {
  const GetPostByIdUseCase(this._repository);

  final PostRepository _repository;

  /// Executes the use case for the post identified by [id].
  Future<Either<Failure, Post>> call(int id) => _repository.getPostById(id);
}
