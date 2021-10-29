import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_infinite_scroll/posts_event.dart';
import 'package:posts_infinite_scroll/posts_state.dart';
import 'package:posts_infinite_scroll/service.dart';

import 'async_request_status.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(const PostsState());

  final _service = Service();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is PostsFetched && state.hasUnfetchedPages) {
      if (state.fetchPostsStatus != AsyncRequestStatus.loading) {
        try {
          yield state.copyWith(fetchPostsStatus: AsyncRequestStatus.loading);

          final pageToFetch = state.lastPage + 1;
          final posts = await _service.getPosts(pageToFetch);

          yield state.copyWith(
              fetchPostsStatus: AsyncRequestStatus.success,
              posts: state.posts + posts,
              lastPage: pageToFetch,
              hasUnfetchedPages: posts.isNotEmpty);
        } catch (_) {
          yield state.copyWith(fetchPostsStatus: AsyncRequestStatus.failure);
        }
      } else {
        // request is loading, do nothing
      }
    }
  }
}
