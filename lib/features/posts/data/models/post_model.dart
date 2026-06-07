// dart run build_runner build --delete-conflicting-outputs
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tokenshell_riverpod/features/posts/domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Data Transfer Object for the /posts endpoint.
///
/// [PostModel] is the JSON-aware representation of a post.
/// Conversion to the pure domain [Post] entity is done by [toDomain].
///
/// Freezed provides: immutability, value equality, copyWith, and toString.
/// json_serializable provides: fromJson / toJson.
@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    @JsonKey(name: 'userId') required int userId,
    required String title,
    required String body,
  }) = _PostModel;

  /// Deserialises a [PostModel] from a JSON map.
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

/// Extension providing clean conversion from [PostModel] to domain [Post].
extension PostModelX on PostModel {
  /// Converts this DTO into the pure domain [Post] entity.
  Post toDomain() => Post(
    id: id,
    userId: userId,
    title: title,
    body: body,
  );
}
