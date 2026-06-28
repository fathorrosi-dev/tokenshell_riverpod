import 'package:fpdart/fpdart.dart';

import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';

/// Abstract contract for the posts data source.
///
/// The domain layer depends ONLY on this interface — never on the concrete
/// implementation in the data layer. This inversion of dependency keeps the
/// domain layer free from framework and library coupling.
abstract interface class PostRepository {
  /// Fetches posts from the remote source.
  ///
  /// [page] and [pageSize] are optional pagination controls — the
  /// jsonplaceholder backend (a json-server instance underneath) accepts
  /// `_page` and `_limit` query parameters for exactly this. Both default
  /// to `null`, which omits the query parameters entirely and fetches the
  /// same full, unpaginated list every existing caller already depends
  /// on — so adding these parameters is a fully backward-compatible
  /// signature change; no existing call site needs to change to keep
  /// compiling or behaving the same.
  ///
  /// Added ahead of any real consumer needing it: this is the reference
  /// list-feature other features in this template copy, so the
  /// pagination shape is decided once, here, rather than retrofitted
  /// later as a breaking change once several features already copied
  /// today's parameterless signature.
  ///
  /// Returns [Right<List<Post>>] on success or [Left<Failure>] on any error.
  Future<Either<Failure, List<Post>>> getPosts({int? page, int? pageSize});

  /// Fetches a single post by its [id].
  ///
  /// Returns [Right<Post>] on success or [Left<Failure>] on any error.
  Future<Either<Failure, Post>> getPostById(int id);
}
