import 'package:fpdart/fpdart.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';

/// Abstract contract for the posts data source.
///
/// The domain layer depends ONLY on this interface — never on the concrete
/// implementation in the data layer. This inversion of dependency keeps the
/// domain layer free from framework and library coupling.
abstract interface class PostRepository {
  /// Fetches all available posts from the remote source.
  ///
  /// Returns [Right<List<Post>>] on success or [Left<Failure>] on any error.
  Future<Either<Failure, List<Post>>> getPosts();

  /// Fetches a single post by its [id].
  ///
  /// Returns [Right<Post>] on success or [Left<Failure>] on any error.
  Future<Either<Failure, Post>> getPostById(int id);
}
