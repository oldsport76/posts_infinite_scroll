import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPostsPage(int page);
}