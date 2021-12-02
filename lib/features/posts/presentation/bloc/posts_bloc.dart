import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_infinite_scroll/features/posts/domain/usecases/get_posts.dart';
import 'package:posts_infinite_scroll/features/posts/presentation/bloc/posts_event.dart';
import 'package:posts_infinite_scroll/features/posts/presentation/bloc/posts_state.dart';

import '../../../../core/utils/async_request_status.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPosts getPosts;

  PostsBloc(this.getPosts) : super(const PostsState());

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is PostsFetched && state.hasUnfetchedPages) {
      if (state.fetchPostsStatus != AsyncRequestStatus.loading) {
        try {
          yield state.copyWith(fetchPostsStatus: AsyncRequestStatus.loading);

          final pageToFetch = state.lastPage + 1;
          final posts = await getPosts(Params(pageNumber: pageToFetch));

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
