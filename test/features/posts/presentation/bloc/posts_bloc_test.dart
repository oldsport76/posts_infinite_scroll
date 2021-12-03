import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posts_infinite_scroll/core/utils/async_request_status.dart';
import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';
import 'package:posts_infinite_scroll/features/posts/domain/usecases/get_posts.dart';
import 'package:posts_infinite_scroll/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:posts_infinite_scroll/features/posts/presentation/bloc/posts_event.dart';
import 'package:posts_infinite_scroll/features/posts/presentation/bloc/posts_state.dart';

import 'posts_bloc_test.mocks.dart';

class MGetPosts extends Mock implements GetPosts {}

@GenerateMocks([MGetPosts])
void main() {
  late PostsBloc bloc;
  late MockMGetPosts mockGetPosts;

  setUp(() {
    mockGetPosts = MockMGetPosts();

    bloc = PostsBloc(mockGetPosts);
  });

  test('initialState should be new', () {
    // assert
    expect(bloc.state, equals(const PostsState()));
  });

  group('GetPosts', () {
    const initialState = PostsState();

    test(
      'should fetch first page of posts',
      () async {
        // act
        bloc.add(PostsFetched());
        await untilCalled(mockGetPosts(any));
        // assert
        verify(mockGetPosts(const Params(pageNumber: 1)));
      },
    );

    test(
      'should enter loading state when page fetched and complete with success',
      () async {
        const post = Post(userId: 1, id: 1, title: null, body: null);
        when(mockGetPosts(any)).thenAnswer((_) async => [post]);

        bloc.add(PostsFetched());

        expectLater(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                  fetchPostsStatus: AsyncRequestStatus.loading),
              initialState.copyWith(
                  posts: [post],
                  lastPage: 1,
                  fetchPostsStatus: AsyncRequestStatus.success)
            ]));
      },
    );

    test(
      'should enter loading state when page fetched and complete with failure',
      () async {
        when(mockGetPosts(any)).thenThrow(Exception());

        bloc.add(PostsFetched());

        expectLater(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                  fetchPostsStatus: AsyncRequestStatus.loading),
              initialState.copyWith(
                  fetchPostsStatus: AsyncRequestStatus.failure)
            ]));
      },
    );

    test(
      'should set hasUnfetchedPages to false when no posts returned',
      () async {
        when(mockGetPosts(any)).thenAnswer((_) async => []);

        bloc.add(PostsFetched());

        expect(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                  fetchPostsStatus: AsyncRequestStatus.loading),
              initialState.copyWith(
                  posts: [],
                  lastPage: 1,
                  hasUnfetchedPages: false,
                  fetchPostsStatus: AsyncRequestStatus.success)
            ]));
      },
    );

    test(
      'should fetch no pages when hasUnfetchedPages false',
          () async {
        when(mockGetPosts(any)).thenAnswer((_) async => []);

        bloc.add(PostsFetched());

        expect(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                  fetchPostsStatus: AsyncRequestStatus.loading),
              initialState.copyWith(
                  posts: [],
                  lastPage: 1,
                  hasUnfetchedPages: false,
                  fetchPostsStatus: AsyncRequestStatus.success)
            ]));

        await untilCalled(mockGetPosts(any));
        bloc.add(PostsFetched());

        expect(
            bloc.stream,
            emits(
                initialState.copyWith(
                    posts: [],
                    lastPage: 1,
                    hasUnfetchedPages: false,
                    fetchPostsStatus: AsyncRequestStatus.success)
            ));
      },
    );

    test(
      'should concatenate post list and complete with success twice',
          () async {
        const post = Post(userId: 1, id: 1, title: null, body: null);
        when(mockGetPosts(any)).thenAnswer((_) async => [post]);

        bloc.add(PostsFetched());

        expect(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                  fetchPostsStatus: AsyncRequestStatus.loading),
              initialState.copyWith(
                  posts: [post],
                  lastPage: 1,
                  fetchPostsStatus: AsyncRequestStatus.success)
            ]));

        await untilCalled(mockGetPosts(any));
        bloc.add(PostsFetched());

        expect(
            bloc.stream,
            emitsInOrder([
              initialState.copyWith(
                  posts: [post],
                  lastPage: 1,
                  fetchPostsStatus: AsyncRequestStatus.success),
              initialState.copyWith(
                  posts: [post],
                  lastPage: 1,
                  fetchPostsStatus: AsyncRequestStatus.loading),
              initialState.copyWith(
                  posts: [post, post],
                  lastPage: 2,
                  fetchPostsStatus: AsyncRequestStatus.success),
            ]));
      },
    );

  });
}
