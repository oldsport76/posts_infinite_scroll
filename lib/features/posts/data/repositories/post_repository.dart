import 'package:posts_infinite_scroll/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';
import 'package:posts_infinite_scroll/features/posts/domain/repositories/i_post_repository.dart';

class PostRepository extends IPostRepository {
  final PostsRemoteDataSource postsRemoteDataSource;

  PostRepository({required this.postsRemoteDataSource});

  @override
  Future<List<Post>> getPostsPage(int page) =>
      postsRemoteDataSource.getPostsPage(page);
}
