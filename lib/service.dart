import 'package:posts_infinite_scroll/get_posts_request.dart';
import 'package:posts_infinite_scroll/post.dart';
import 'package:posts_infinite_scroll/transport.dart';

class Service {
  final _transport = Transport();

  Future<List<Post>> getPosts(int pageNumber) =>
      _transport.execute(GetPostsRequest(pageNumber));
}
