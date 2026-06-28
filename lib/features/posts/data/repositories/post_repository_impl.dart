import 'package:fpdart/fpdart.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/core/errors/failure_mapper.dart';
import 'package:tokenshell_riverpod/core/network/connectivity_guard.dart';
import 'package:tokenshell_riverpod/features/posts/data/datasources/post_remote_source.dart';
import 'package:tokenshell_riverpod/features/posts/data/models/post_model.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/domain/repositories/post_repository.dart';

/// Concrete implementation of [PostRepository].
///
/// Responsibility: coordinate the remote source, map DTOs to domain
/// entities, and translate every possible exception into a typed
/// [Failure] via the shared [FailureMapper].
///
/// ## ConnectivityGuard (updated R-05, 27 Jun 2026)
///
/// [_connectivity] now returns `Either<NetworkFailure, Unit>` instead of
/// throwing. Each method pattern-matches on the result with a Dart 3
/// `if (guard case Left(:final value)) return Left(value)` guard:
///
/// - `Left` → propagated immediately as `Left<Failure, T>` (safe because
///   [NetworkFailure] is a [Failure] subtype, so the left channel widens).
/// - `Right(unit)` → device is online, proceeds to the actual HTTP call.
///
/// This replaces the previous try/catch pattern where [ConnectivityGuard]
/// threw a [NetworkFailure] that had to be intercepted by the `on Exception`
/// clause. That implicit throw↔catch contract was invisible to the compiler:
/// changing the catch to `on DioException` would silently let [NetworkFailure]
/// escape uncaught. With Either, a missed result is a type error, not a
/// runtime surprise.
///
/// The `on Exception` clause remains — it now guards only the HTTP call,
/// which is its correct and intended scope.
///
/// Rules:
/// - Every expected (`Exception`-based) failure becomes a [Failure],
///   returned inside [Left].
/// - Domain objects ([Post]) are returned inside [Right].
final class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl({
    required PostRemoteSource remoteSource,
    required ConnectivityGuard connectivityGuard,
    required FailureMapper failureMapper,
  }) : _remote = remoteSource,
       _connectivity = connectivityGuard,
       _failureMapper = failureMapper;

  final PostRemoteSource _remote;
  final ConnectivityGuard _connectivity;
  final FailureMapper _failureMapper;

  @override
  Future<Either<Failure, List<Post>>> getPosts({
    int? page,
    int? pageSize,
  }) async {
    // Guard: bail early if offline.
    // NetworkFailure is a Failure subtype — the left channel widens correctly.
    final guard = await _connectivity();
    if (guard case Left(:final value)) return Left(value);

    try {
      final models = await _remote.getPosts(page: page, pageSize: pageSize);
      return Right(models.map((m) => m.toDomain()).toList());
    } on Exception catch (error, stackTrace) {
      return Left(_failureMapper(error, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostById(int id) async {
    // Guard: bail early if offline.
    // NetworkFailure is a Failure subtype — the left channel widens correctly.
    final guard = await _connectivity();
    if (guard case Left(:final value)) return Left(value);

    try {
      final model = await _remote.getPostById(id);
      return Right(model.toDomain());
    } on Exception catch (error, stackTrace) {
      return Left(_failureMapper(error, stackTrace));
    }
  }
}
