import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

/// Pure domain entity representing a single blog post.
///
/// Lives in the Domain layer — deliberately free of Flutter SDK imports,
/// serialisation mechanisms, and Data-layer dependencies. JSON mapping
/// lives exclusively in [PostModel] (data layer); [PostModelX.toDomain]
/// converts between the two.
///
/// Freezed provides value equality, immutability, [copyWith], and a
/// human-readable [toString] — keeping the class consistent with
/// [PostModel] and removing the risk of missing field updates that came
/// with the previous manual [==] / [hashCode] / [toString] implementation.
@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) = _Post;
}
