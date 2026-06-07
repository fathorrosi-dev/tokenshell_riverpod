import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/data/models/post_model.dart';
import 'package:tokenshell_riverpod/features/posts/data/sources/post_remote_source.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/domain/repositories/post_repository.dart';

/// Concrete implementation of [PostRepository].
///
/// Responsibility: coordinate the remote source, map DTOs to domain entities,
/// and translate every possible exception into a typed [Failure].
///
/// Rules:
/// - No raw exception propagates beyond this class.
/// - Every catch block returns [Left<Failure>].
/// - Domain objects ([Post]) are returned inside [Right].
final class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl({
    required PostRemoteSource remoteSource,
    required ConnectivityGuard connectivityGuard,
  }) : _remote = remoteSource,
       _connectivity = connectivityGuard;

  final PostRemoteSource _remote;

  /// Callable that checks connectivity and throws [NetworkFailure] if absent.
  final ConnectivityGuard _connectivity;

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      await _connectivity();
      final models = await _remote.getPosts();
      return Right(models.map((m) => m.toDomain()).toList());
    } on NetworkFailure catch (e, st) {
      return Left(NetworkFailure(message: e.message, stackTrace: st));
    } on DioException catch (e, st) {
      return Left(_mapDioException(e, st));
    } on UnknownFailure catch (e, st) {
      return Left(UnknownFailure(message: e.toString(), stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Post>> getPostById(int id) async {
    try {
      await _connectivity();
      final model = await _remote.getPostById(id);
      return Right(model.toDomain());
    } on NetworkFailure catch (e, st) {
      return Left(NetworkFailure(message: e.message, stackTrace: st));
    } on DioException catch (e, st) {
      return Left(_mapDioException(e, st));
    } on UnknownFailure catch (e, st) {
      return Left(UnknownFailure(message: e.toString(), stackTrace: st));
    }
  }

  // ── Exception → Failure mapping ─────────────────────────────────────────────

  Failure _mapDioException(DioException e, StackTrace st) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError => NetworkFailure(
        message: e.message ?? 'Connection error.',
        stackTrace: st,
      ),
      DioExceptionType.badResponse => ServerFailure(
        message:
            e.response?.statusMessage ??
            'Server returned an error (${e.response?.statusCode}).',
        statusCode: e.response?.statusCode,
        stackTrace: st,
      ),
      _ => UnknownFailure(
        message: e.message ?? 'Unknown Dio error.',
        stackTrace: st,
      ),
    };
  }
}

// ── Connectivity guard type alias ─────────────────────────────────────────────

/// A callable that performs a one-shot connectivity check.
/// Throws [NetworkFailure] if no connection is available.
typedef ConnectivityGuard = Future<void> Function();
