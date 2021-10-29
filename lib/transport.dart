import 'dart:convert';

import 'package:http/http.dart';
import 'package:posts_infinite_scroll/request.dart';

class Transport {
  final _http = Client();

  Future<T> execute<T, R extends HttpRequest>(R request) {
    return _buildURI(request)
        .then((uri) => _issueRequest(uri, request))
        .then((response) {
      return request.parse(response.statusCode, jsonDecode(response.body));
    });
  }

  Future<Uri> _buildURI(HttpRequest request) async => Uri.https(
      'jsonplaceholder.typicode.com',
      request.path!,
      request.queryParameters);

  Future<Response> _issueRequest(Uri uri, HttpRequest request) {
    switch (request.method) {
      case HTTPMethod.get:
        return _http.get(uri, headers: request.headers);

      case HTTPMethod.post:
        return _http.post(uri, body: request.body);

      default:
        return Future.value();
    }
  }
}
