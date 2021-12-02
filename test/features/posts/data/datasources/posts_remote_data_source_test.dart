import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_infinite_scroll/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:posts_infinite_scroll/features/posts/data/models/post_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'posts_remote_data_source_test.mocks.dart';

class HttpClient extends Mock implements http.Client {}

@GenerateMocks([HttpClient])
void main() {
  late PostsRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = PostsRemoteDataSource(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('posts.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getPosts', () {
    const pageNumber = 0;

    final json = jsonDecode(fixture('posts.json')) as List<dynamic>;
    final postModelList = json.map((e) => PostModel.fromJson(e)).toList();

    test(
      '''should perform a GET request on a URL with number
       being the page index and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        await dataSource.getPostsPage(pageNumber);
        // assert
        verify(mockHttpClient.get(
          Uri.https('jsonplaceholder.typicode.com', 'posts',
              {'_page': pageNumber.toString()}),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return post list when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getPostsPage(pageNumber);
        // assert
        expect(result, equals(postModelList));
      },
    );

    test(
      'should throw an Exception when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getPostsPage;
        // assert
        expect(() => call(pageNumber), throwsA(const TypeMatcher<Exception>()));
      },
    );
  });
}
