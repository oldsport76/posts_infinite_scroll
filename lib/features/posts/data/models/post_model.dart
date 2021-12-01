import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({userId, id, title, body})
      : super(userId: userId, id: id, title: title, body: body);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'],
      id: (json['id'] as num).toInt(),
      title: json['title'],
      body: json['body']
    );
  }
}
