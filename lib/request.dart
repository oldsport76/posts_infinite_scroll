abstract class HttpRequest<T> {
  String? path;
  HTTPMethod? method;
  Map<String, String>? headers;
  Map<String, String>? queryParameters;
  dynamic body;

  T parse(int httpsStatus, List<dynamic> json);
}

enum HTTPMethod {
  get,
  post,
  put,
  patch,
  delete
}