import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:posts_infinite_scroll/features/posts/data/models/post_model.dart';
import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {

  const postModel = PostModel(userId: 1, id: 1, title: 'lol', body: 'kek');

  group('fromJson', () {
    test(
      'should return a valid model',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap =
        jsonDecode(fixture('post.json'));
        // act
        final result = PostModel.fromJson(jsonMap);
        // assert
        expect(result, postModel);
      },
    );

    test(
      'should return a valid model when fields missing in json',
        () async {
        // arrange
          final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('post_missing_fields.json'));

          // act
          final result = PostModel.fromJson(jsonMap);

          // assert
          expect(result, isA<Post>());
        }
    );

    test(
        'should return a valid model when fields null in json',
            () async {
          // arrange
          final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('post_null_fields.json'));

          // act
          final result = PostModel.fromJson(jsonMap);

          // assert
          expect(result, isA<Post>());
        }
    );
  });

}