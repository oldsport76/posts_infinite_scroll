import 'package:posts_infinite_scroll/post.dart';
import 'package:posts_infinite_scroll/request.dart';

class GetPostsRequest extends HttpRequest {
  @override
  get method => HTTPMethod.get;
  @override
  get path => 'posts';

  final int pageNumber;

  GetPostsRequest(this.pageNumber) {
    queryParameters = {};
    queryParameters!['_page'] = pageNumber.toString();
  }

  @override
  List<Post> parse(int httpsStatus, List<dynamic> json) =>
      json.isNotEmpty ? json.map((e) => _postFromRaw(e)).toList() : [];

  Post _postFromRaw(dynamic p) {
    // library can be used for this, though client may not need all fields
    // or wishes to rename part thereof
    final int? userId = p['userId'];
    final int? id = p['id'];
    final String? title = p['title'];
    final String body = p['body'];

    return Post(userId: userId, id: id, title: title, body: body);
  }
}
