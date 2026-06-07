import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tokenshell_riverpod/core/errors/failure.dart';
import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';
import 'package:tokenshell_riverpod/features/posts/domain/repositories/post_repository.dart';
import 'package:tokenshell_riverpod/features/posts/domain/usecases/get_posts_usecase.dart';

// ── Mocks ──────────────────────────────────────────────────────────────────────

class _MockPostRepository extends Mock implements PostRepository {}

// ── Fixtures ───────────────────────────────────────────────────────────────────

const _tPosts = [
  Post(id: 1, userId: 1, title: 'First post', body: 'Body one.'),
  Post(id: 2, userId: 2, title: 'Second post', body: 'Body two.'),
];

void main() {
  late _MockPostRepository mockRepository;
  late GetPostsUseCase useCase;

  setUp(() {
    mockRepository = _MockPostRepository();
    useCase = GetPostsUseCase(mockRepository);
  });

  group('GetPostsUseCase', () {
    test(
      'returns Right(List<Post>) when repository returns Right',
      () async {
        // Arrange
        when(() => mockRepository.getPosts())
            .thenAnswer((_) async => const Right(_tPosts));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected Right but got Left'),
          (posts) {
            expect(posts, equals(_tPosts));
            expect(posts.length, equals(2));
          },
        );
        verify(() => mockRepository.getPosts()).called(1);
      },
    );

    test(
      'returns Left(NetworkFailure) when repository returns Left(NetworkFailure)',
      () async {
        // Arrange
        const failure = NetworkFailure();
        when(() => mockRepository.getPosts())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test(
      'returns Left(ServerFailure) when repository returns Left(ServerFailure)',
      () async {
        // Arrange
        const failure = ServerFailure(message: 'Internal Server Error');
        when(() => mockRepository.getPosts())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (f) {
            expect(f, isA<ServerFailure>());
            expect((f as ServerFailure).message, equals('Internal Server Error'));
          },
          (_) => fail('Expected Left but got Right'),
        );
      },
    );

    test(
      'calls repository.getPosts exactly once per invocation',
      () async {
        // Arrange
        when(() => mockRepository.getPosts())
            .thenAnswer((_) async => const Right(_tPosts));

        // Act
        await useCase();
        await useCase();

        // Assert — each call() triggers one repository fetch
        verify(() => mockRepository.getPosts()).called(2);
      },
    );

    test(
      'passes the Left value through without transformation',
      () async {
        // Arrange — use case must NOT swallow or mutate the Failure
        const originalFailure = UnknownFailure(message: 'Raw error');
        when(() => mockRepository.getPosts())
            .thenAnswer((_) async => const Left(originalFailure));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (f) {
            expect(f, isA<UnknownFailure>());
            expect(f.message, equals('Raw error'));
          },
          (_) => fail('Expected Left but got Right'),
        );
      },
    );
  });
}
