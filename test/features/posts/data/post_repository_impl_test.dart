import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/data/models/post_model.dart';
import 'package:tokenshell_riverpod/features/posts/data/repositories/post_repository_impl.dart';
import 'package:tokenshell_riverpod/features/posts/data/sources/post_remote_source.dart';

// ── Mocks ──────────────────────────────────────────────────────────────────────

class _MockPostRemoteSource extends Mock implements PostRemoteSource {}

// ── Fakes ──────────────────────────────────────────────────────────────────────

class _FakeRequestOptions extends Fake implements RequestOptions {}

// ── Fixtures ───────────────────────────────────────────────────────────────────

final _tPostModels = [
  const PostModel(id: 1, userId: 1, title: 'First post', body: 'Body one.'),
  const PostModel(id: 2, userId: 1, title: 'Second post', body: 'Body two.'),
];

// ── Helpers ────────────────────────────────────────────────────────────────────

/// Returns a [PostRepositoryImpl] wired with [source] and a no-op connectivity
/// guard (connectivity is checked separately; we test the repository in isolation).
PostRepositoryImpl _makeRepo(
  PostRemoteSource source, {
  bool connected = true,
}) {
  return PostRepositoryImpl(
    remoteSource: source,
    connectivityGuard: connected
        ? () async {} // online — guard passes silently
        : () async => throw const NetworkFailure(),
  );
}

void main() {
  late _MockPostRemoteSource mockSource;

  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
  });

  setUp(() {
    mockSource = _MockPostRemoteSource();
  });

  group('PostRepositoryImpl', () {
    group('getPosts()', () {
      test(
        'returns Right(List<Post>) when remote source succeeds',
        () async {
          // Arrange
          when(() => mockSource.getPosts())
              .thenAnswer((_) async => _tPostModels);
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPosts();

          // Assert
          expect(result.isRight(), isTrue);
          result.fold(
            (_) => fail('Expected Right but got Left'),
            (posts) {
              expect(posts.length, equals(2));
              expect(posts.first.id, equals(1));
              expect(posts.first.title, equals('First post'));
            },
          );
        },
      );

      test(
        'returns Left(NetworkFailure) when device has no connection',
        () async {
          // Arrange
          final repo = _makeRepo(mockSource, connected: false);

          // Act
          final result = await repo.getPosts();

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'returns Left(NetworkFailure) when DioException is a connection timeout',
        () async {
          // Arrange
          when(() => mockSource.getPosts()).thenThrow(
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: '/posts'),
              message: 'Connection timed out',
            ),
          );
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPosts();

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'returns Left(ServerFailure) when server returns a 500 response',
        () async {
          // Arrange
          when(() => mockSource.getPosts()).thenThrow(
            DioException(
              type: DioExceptionType.badResponse,
              requestOptions: RequestOptions(path: '/posts'),
              response: Response(
                requestOptions: RequestOptions(path: '/posts'),
                statusCode: 500,
                statusMessage: 'Internal Server Error',
              ),
            ),
          );
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPosts();

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              final server = failure as ServerFailure;
              expect(server.statusCode, equals(500));
            },
            (_) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'returns Left(ServerFailure) when server returns a 404 response',
        () async {
          // Arrange
          when(() => mockSource.getPosts()).thenThrow(
            DioException(
              type: DioExceptionType.badResponse,
              requestOptions: RequestOptions(path: '/posts'),
              response: Response(
                requestOptions: RequestOptions(path: '/posts'),
                statusCode: 404,
                statusMessage: 'Not Found',
              ),
            ),
          );
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPosts();

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              final server = failure as ServerFailure;
              expect(server.statusCode, equals(404));
            },
            (_) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'returns Left(UnknownFailure) when an unexpected exception is thrown',
        () async {
          // Arrange
          when(() => mockSource.getPosts())
              .thenThrow(Exception('Something unexpected'));
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPosts();

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<UnknownFailure>()),
            (_) => fail('Expected Left but got Right'),
          );
        },
      );
    });

    group('getPostById()', () {
      test(
        'returns Right(Post) when remote source returns a single PostModel',
        () async {
          // Arrange
          when(() => mockSource.getPostById(1))
              .thenAnswer((_) async => _tPostModels.first);
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPostById(1);

          // Assert
          expect(result.isRight(), isTrue);
          result.fold(
            (_) => fail('Expected Right but got Left'),
            (post) {
              expect(post.id, equals(1));
              expect(post.title, equals('First post'));
            },
          );
        },
      );

      test(
        'returns Left(ServerFailure) when getPostById throws DioException 404',
        () async {
          // Arrange
          when(() => mockSource.getPostById(any())).thenThrow(
            DioException(
              type: DioExceptionType.badResponse,
              requestOptions: RequestOptions(path: '/posts/999'),
              response: Response(
                requestOptions: RequestOptions(path: '/posts/999'),
                statusCode: 404,
                statusMessage: 'Not Found',
              ),
            ),
          );
          final repo = _makeRepo(mockSource);

          // Act
          final result = await repo.getPostById(999);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left but got Right'),
          );
        },
      );
    });
  });
}
