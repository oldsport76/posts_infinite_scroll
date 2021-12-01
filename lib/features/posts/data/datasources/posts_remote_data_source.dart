import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posts_infinite_scroll/features/posts/data/models/post_model.dart';

abstract class IPostsRemoteDataSource {
  Future<List<PostModel>> getPostsPage(int page);
}

class PostsRemoteDataSource extends IPostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSource({required this.client});

  @override
  Future<List<PostModel>> getPostsPage(int page) async {
    final response = await client.get(
      Uri.https(
          'jsonplaceholder.typicode.com', 'posts', {'_page': page.toString()}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Get posts page request status code is not 200");
    } else {
      final json = jsonDecode(response.body) as List<dynamic>;
      return json.isNotEmpty
          ? json.map((e) => PostModel.fromJson(e)).toList()
          : [];
    }
  }
}
