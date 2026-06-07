import 'package:flutter/foundation.dart';
import 'package:tokenshell_riverpod/features/posts/data/models/post_model.dart';

/// Pure domain entity representing a single blog post.
///
/// This class lives in the domain layer and has NO dependency on any
/// external package, framework, or serialisation mechanism.
/// JSON mapping is the responsibility of [PostModel] in the data layer.
@immutable
final class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int id;
  final int userId;
  final String title;
  final String body;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode => Object.hash(id, userId, title, body);

  @override
  String toString() => 'Post(id: $id, userId: $userId, title: $title)';
}
