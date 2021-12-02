import 'package:equatable/equatable.dart';
import 'package:posts_infinite_scroll/core/utils/async_request_status.dart';
import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';

class PostsState extends Equatable {
  const PostsState(
      {this.posts = const [],
      this.lastPage = 0,
      this.hasUnfetchedPages = true,
      this.fetchPostsStatus = AsyncRequestStatus.uninitialized});

  final List<Post> posts;
  final int lastPage;
  final bool hasUnfetchedPages;
  final AsyncRequestStatus fetchPostsStatus;

  PostsState copyWith(
          {List<Post>? posts,
          int? lastPage,
          bool? hasUnfetchedPages,
          AsyncRequestStatus? fetchPostsStatus}) =>
      PostsState(
          posts: posts ?? this.posts,
          lastPage: lastPage ?? this.lastPage,
          hasUnfetchedPages: hasUnfetchedPages ?? this.hasUnfetchedPages,
          fetchPostsStatus: fetchPostsStatus ?? this.fetchPostsStatus);

  @override
  List<Object?> get props =>
      [posts, lastPage, hasUnfetchedPages, fetchPostsStatus];
}
