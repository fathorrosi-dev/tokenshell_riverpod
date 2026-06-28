import 'package:fpdart/fpdart.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/domain/repositories/post_repository.dart';

/// Retrieves the full list of posts.
///
/// A use case encapsulates a single business action and depends only on the
/// abstract [PostRepository] interface — never on a concrete data class.
///
/// Return type is [Future<Either<Failure, List<Post>>>]:
///   - [Right]  → success path with the resolved list.
///   - [Left]   → failure path with a typed [Failure] variant.
final class GetPostsUseCase {
  const GetPostsUseCase(this._repository);

  final PostRepository _repository;

  /// Executes the use case.
  ///
  /// [page] / [pageSize] forward directly to [PostRepository.getPosts] —
  /// see that method's doc comment for what omitting them does.
  Future<Either<Failure, List<Post>>> call({int? page, int? pageSize}) =>
      _repository.getPosts(page: page, pageSize: pageSize);
}
